from PIL import Image
import matplotlib

def hex_to_rgb(hex_color):
    """Convert a hex color string to an RGB tuple."""
    return matplotlib.colors.hex2color(hex_color)

def create_gradient_image(width, height, top_left_hex, top_right_hex, bottom_left_hex, bottom_right_hex):
    top_left = tuple(int(c * 255) for c in hex_to_rgb(top_left_hex))
    top_right = tuple(int(c * 255) for c in hex_to_rgb(top_right_hex))
    bottom_left = tuple(int(c * 255) for c in hex_to_rgb(bottom_left_hex))
    bottom_right = tuple(int(c * 255) for c in hex_to_rgb(bottom_right_hex))

    img = Image.new('RGB', (width, height), (255, 255, 255))

    def interpolate(c1, c2, factor):
        return tuple(int(c1[i] * (1 - factor) + c2[i] * factor) for i in range(3))

    for y in range(height):
        for x in range(width):
            top_factor = x / width
            left_factor = y / height
            top_color = interpolate(top_left, top_right, top_factor)
            bottom_color = interpolate(bottom_left, bottom_right, top_factor)
            final_color = interpolate(top_color, bottom_color, left_factor)
            img.putpixel((x, y), final_color)

    return img


create_gradient_image(
    1024, 800,
    # '#585b70',
    # '#313244',


    '#fad000',
    '#89b4fa',
    '#b4befe',
    '#cdd6f4',

).save("wallpaper.png")
