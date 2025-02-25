# Lib: EditMode

## [8](https://github.com/p3lim-wow/LibEditMode/tree/8) (2024-07-23)
[Full Changelog](https://github.com/p3lim-wow/LibEditMode/commits/8) [Previous Releases](https://github.com/p3lim-wow/LibEditMode/releases)

- Bump minor  
- Use multi-valued interface version  
- Bump peter-evans/create-pull-request from 5 to 6  
    Bumps [peter-evans/create-pull-request](https://github.com/peter-evans/create-pull-request) from 5 to 6.  
    - [Release notes](https://github.com/peter-evans/create-pull-request/releases)  
    - [Commits](https://github.com/peter-evans/create-pull-request/compare/v5...v6)  
    ---  
    updated-dependencies:  
    - dependency-name: peter-evans/create-pull-request  
      dependency-type: direct:production  
      update-type: version-update:semver-major  
    ...  
    Signed-off-by: dependabot[bot] <support@github.com>  
- Bump actions/upload-artifact from 3 to 4  
    Bumps [actions/upload-artifact](https://github.com/actions/upload-artifact) from 3 to 4.  
    - [Release notes](https://github.com/actions/upload-artifact/releases)  
    - [Commits](https://github.com/actions/upload-artifact/compare/v3...v4)  
    ---  
    updated-dependencies:  
    - dependency-name: actions/upload-artifact  
      dependency-type: direct:production  
      update-type: version-update:semver-major  
    ...  
    Signed-off-by: dependabot[bot] <support@github.com>  
- Bump Interface version  
- Remove old embeds and references  
- :broom:  
- Rename TOC to avoid loading on unsupported versions  
- Bump TOC  
- Support changing menu height  
- Use unsecured pool variant  
    Not entirely sure this will stay  
- :broom:  
- Drop LibDropDown for 11.x built-in system  
    It's a drop-in system for simple dropdowns, but any entry types other  
    than checkboxes and radio buttons are not supported by the simple menu.  
    A complex menu can be made using the generator callback.  
- Use stock pools logic as much we can  
- Share tables  
- Use future TOC bumps  
    # Conflicts:  
    #	.github/workflows/version.yml  
- Create FUNDING.yml  
- Update Interface version  
- Bump actions/checkout from 3 to 4  
    Bumps [actions/checkout](https://github.com/actions/checkout) from 3 to 4.  
    - [Release notes](https://github.com/actions/checkout/releases)  
    - [Changelog](https://github.com/actions/checkout/blob/main/CHANGELOG.md)  
    - [Commits](https://github.com/actions/checkout/compare/v3...v4)  
    ---  
    updated-dependencies:  
    - dependency-name: actions/checkout  
      dependency-type: direct:production  
      update-type: version-update:semver-major  
    ...  
    Signed-off-by: dependabot[bot] <support@github.com>  
- Bump p3lim/toc-interface-updater from 2 to 3  
    Bumps [p3lim/toc-interface-updater](https://github.com/p3lim/toc-interface-updater) from 2 to 3.  
    - [Release notes](https://github.com/p3lim/toc-interface-updater/releases)  
    - [Commits](https://github.com/p3lim/toc-interface-updater/compare/v2...v3)  
    ---  
    updated-dependencies:  
    - dependency-name: p3lim/toc-interface-updater  
      dependency-type: direct:production  
      update-type: version-update:semver-major  
    ...  
    Signed-off-by: dependabot[bot] <support@github.com>  
- Update license  
- :broom:  
- Update version  
- Revert dc15c87  
- Securely dispatch callbacks  
- Manually trigger layout callbacks registering late  
- Update version  
- Use override name for dialog title  
- Fix checked status for dropdown labels  
- Fallback on defaults correctly  
- Correctly reset settings objects  
- Fix bogus dep  
- Bump Interface version  
- Add override for label name  
- Bump p3lim/license-year-updater from 1 to 2  
    Bumps [p3lim/license-year-updater](https://github.com/p3lim/license-year-updater) from 1 to 2.  
    - [Release notes](https://github.com/p3lim/license-year-updater/releases)  
    - [Commits](https://github.com/p3lim/license-year-updater/compare/v1...v2)  
    ---  
    updated-dependencies:  
    - dependency-name: p3lim/license-year-updater  
      dependency-type: direct:production  
      update-type: version-update:semver-major  
    ...  
    Signed-off-by: dependabot[bot] <support@github.com>  
- Bump version  
- Bump workflow actions  
- Bump Interface version  
- Fix for 10.1  
    Fix #12  
- LDD refreshes menus itself in minor9  
- Update Interface version (#9)  
    Co-authored-by: p3lim <p3lim@users.noreply.github.com>  
- Merge pull request #8 from p3lim-wow/update-license  
    Update license  
- Update license  
- Update version  
- Only bump minor  
- Linting  
- That's not how this works  
- There might not be an old minor  
- Add note about lib.dialog compat  
- Add utility to help with tagging  
    Since we define MINOR in multiple places it's crucial they are equal  
- Almost missed a file  
- Update Interface version  
- Only attempt to refresh dropdowns if the lib supports it  
- Add version compatibility checks and backports  
- Add note  
- Don't lint tests  
- Add a functional example to use for testing/validation  
- Return a boolean  
- Refresh dropdowns on selection  
- Document the layout callback signature  
- Namespace internal methods and drop their docs  
- Doc adjustments  
- Document types  
- Ignore trailing whitespace in comments  
- Fix links  
- Fixup  
- Create page for object types  
- Fix some links  
- Document most of the functionality  
- Set up automated releases  
- Update version  
- Force hide selections when we leave edit mode  
- :sparkles:  
