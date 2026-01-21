#!/usr/bin/env python3
"""
Generate horizontal slider thumb texture for WoW addon
Creates a crystal-clear, professional-looking horizontal thumb texture
"""

from PIL import Image, ImageDraw

def create_horizontal_slider_thumb():
    """Create a professional horizontal slider thumb texture"""
    # Create 16x16 horizontal thumb (square for better fit)
    width, height = 16, 16
    
    # Create base image with transparency
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Solid color fill with flat corners - medium gray with blue tint
    draw.rectangle([(0, 0), (width - 1, height - 1)], fill=(70, 70, 90, 255))
    
    # Add border with flat corners
    draw.rectangle(
        [(0, 0), (width - 1, height - 1)],
        outline=(0, 153, 255, 180),
        width=1
    )
    
    # Save with no compression for maximum sharpness
    img.save('slider_thumb_horizontal.png', 'PNG', optimize=False)
    print("Created: slider_thumb_horizontal.png (16x16 pixels)")

def main():
    create_horizontal_slider_thumb()
    print("\nHorizontal slider thumb texture created successfully!")
    print("File is optimized for sharpness and can be used for horizontal sliders.")

if __name__ == '__main__':
    main()
