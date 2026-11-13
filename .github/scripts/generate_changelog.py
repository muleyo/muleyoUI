#!/usr/bin/env python3
"""Writes the in-game changelog (Config/ChangelogData.lua) from the commits between two tags.

    generate_changelog.py <tag> [--previous <tag>] [--out <file>]

The release workflow runs this when a tag is pushed, before the packager zips the addon. The previous tag is the closest tag before
the given one, unless it is given.

What ends up in the changelog is the subject of each commit, with a few rules:
  - Commits that only change things outside of the addon (workflows, readme, ...) are left out, and so is anything with
    "[skip changelog]" in its subject.
  - Which game version a change is for comes from the files of the commit: Modules/Forever and Config/Layouts/Forever are Forever,
    the Mainline ones are Mainline, everything else is for both. A "(Forever)", "(Mainline)" or "(Retail)" in the subject says it
    outright instead, and is taken out of the text. "(Forever & Retail)" works too.
"""
import argparse
import re
import subprocess
import sys

FLAVORS = ("Forever", "Mainline")

FLAVOR_DIRECTORIES = {
    "Forever": ("Modules/Forever/", "Config/Layouts/Forever/"),
    "Mainline": ("Modules/Mainline/", "Config/Layouts/Mainline/"),
}

# Not part of the addon, a commit that only has these is not in the changelog
NOT_ADDON_PREFIXES = (".github/", ".vscode/")
NOT_ADDON_FILES = {"README.md", "LICENSE", ".pkgmeta", ".gitignore", "CHANGELOG.md", "Config/ChangelogData.lua"}

# Touched by almost everything for one client (defaults, load lists), they don't make a change a change for both
NEUTRAL_FILES = {"Config/Database.lua", "Config/Load.xml", "mUI.toc"}

SKIP_MARKER = "[skip changelog]"
MAX_WITHOUT_PREVIOUS = 25

FLAVOR_WORD = r"(?:forever|mainline|retail)"
FLAVOR_TAG = re.compile(r"\s*\(\s*(" + FLAVOR_WORD + r"(?:\s*(?:,|&|/|and)\s*" + FLAVOR_WORD + r")*)\s*\)", re.IGNORECASE)


def git(*args):
    return subprocess.run(["git", *args], check=True, capture_output=True, text=True, encoding="utf-8").stdout


def previous_tag(tag):
    try:
        return git("describe", "--tags", "--abbrev=0", tag + "^").strip() or None
    except subprocess.CalledProcessError:
        return None


def flavors_of_files(files):
    """The game versions the files are for, nothing if none of them is part of the addon."""
    specific = set()
    shared = False
    neutral = False

    for path in files:
        if path in NOT_ADDON_FILES or path.endswith(".md") or path.startswith(NOT_ADDON_PREFIXES):
            continue

        for flavor, directories in FLAVOR_DIRECTORIES.items():
            if path.startswith(directories):
                specific.add(flavor)
                break
        else:
            if path in NEUTRAL_FILES:
                neutral = True
            else:
                shared = True

    if shared:
        return set(FLAVORS)
    if specific:
        return specific
    if neutral:
        return set(FLAVORS)
    return set()


def flavors_of_subject(subject):
    """(text without the tags, the game versions they name or an empty set)"""
    named = set()
    for match in FLAVOR_TAG.finditer(subject):
        for word in re.findall(FLAVOR_WORD, match.group(1), re.IGNORECASE):
            named.add("Mainline" if word.lower() in ("retail", "mainline") else "Forever")

    text = FLAVOR_TAG.sub("", subject).strip(" -:;,")
    return text, named


def read_commits(previous, tag):
    revisions = (previous + ".." + tag) if previous else tag
    command = ["log", "--no-merges", "--format=%H%x1f%s", revisions]
    if not previous:
        command.insert(1, "-" + str(MAX_WITHOUT_PREVIOUS))

    commits = []
    for line in git(*command).splitlines():
        sha, _, subject = line.partition("\x1f")
        if sha:
            commits.append((sha, subject.strip()))
    return commits


def build_changes(commits):
    changes = []
    # The same text for each game version (two commits, one per client) is one change for both
    position = {}
    for sha, subject in commits:
        if not subject or SKIP_MARKER in subject.lower():
            continue

        text, named = flavors_of_subject(subject)
        if not text:
            continue

        files = git("diff-tree", "--no-commit-id", "--name-only", "-r", "--root", sha).splitlines()
        flavors = named or flavors_of_files(files)
        if not flavors:
            continue

        key = text.lower()
        if key in position:
            known = changes[position[key]]
            flavors |= set(known[1])
            changes[position[key]] = (known[0], [flavor for flavor in FLAVORS if flavor in flavors])
        else:
            position[key] = len(changes)
            changes.append((text, [flavor for flavor in FLAVORS if flavor in flavors]))
    return changes


def lua_string(text):
    # "|" starts a color code or another escape in the game, "||" is a bar
    text = text.replace("\\", "\\\\").replace('"', '\\"').replace("|", "||")
    return '"' + text.replace("\r", "").replace("\n", "\\n").replace("\t", " ") + '"'


def to_lua(tag, changes):
    lines = [
        "-- Made by .github/scripts/generate_changelog.py when a release is built, from the commits since the last release.",
        "-- This is what is in the repository for the versions that are not built by it: no changelog.",
        "mUI.ChangelogData = {",
        "    version = " + lua_string(tag) + ",",
        "    changes = {",
    ]

    for text, flavors in changes:
        entry = "        { text = " + lua_string(text)
        # All game versions is no list
        if len(flavors) != len(FLAVORS):
            entry += ", flavors = { " + ", ".join(lua_string(flavor) for flavor in flavors) + " }"
        lines.append(entry + " },")

    lines += ["    }", "}", ""]
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("tag")
    parser.add_argument("--previous", help="the tag to start after, the closest one before the tag by default")
    parser.add_argument("--out", default="Config/ChangelogData.lua")
    args = parser.parse_args()

    previous = args.previous or previous_tag(args.tag)
    changes = build_changes(read_commits(previous, args.tag))

    with open(args.out, "w", encoding="utf-8", newline="\n") as handle:
        handle.write(to_lua(args.tag, changes))

    print("Changelog of {} (since {}): {} changes -> {}".format(args.tag, previous or "the beginning", len(changes), args.out))
    for text, flavors in changes:
        print("  [{}] {}".format("/".join(flavors), text))
    return 0


if __name__ == "__main__":
    sys.exit(main())
