#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 -p python3Packages.pygobject3

import os
import sys
import gi
import subprocess

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, GdkPixbuf


class ImageCaptionViewer(Gtk.Window):
    def __init__(self, dataset_dir, caption_ext):
        super().__init__(title="Image/Caption Dataset Viewer")
        self.dataset_dir = dataset_dir
        self.caption_ext = caption_ext
        self.image_files = self._get_image_files()
        self.current_index = 0
        self.original_pixbuf = None  # Store the original pixbuf

        self.set_default_size(800, 600)
        self.set_border_width(10)

        # Main layout
        self.layout = Gtk.VBox(spacing=10)
        self.add(self.layout)

        # Image display area
        self.image = Gtk.Image()
        # Allow the image to expand and fill available space
        self.layout.pack_start(self.image, True, True, 0)
        # Connect the size-allocate signal to resize the image
        self.image.connect("size-allocate", self._scale_and_display_image)


        # Caption display area
        self.caption_label = Gtk.Label()
        self.caption_label.set_line_wrap(True)
        # Caption should not expand, taking only the space it needs
        self.layout.pack_start(self.caption_label, False, False, 0)

        # Connect key press event
        self.connect("key-press-event", self.on_key_press)

        # Load the first image and caption if available
        if self.image_files:
            self.load_image_and_caption(self.current_index)
        else:
            self.caption_label.set_text("No images found in the specified directory.")

    def _get_image_files(self):
        """Retrieve all image files with a corresponding caption file in the dataset directory."""
        files = os.listdir(self.dataset_dir)
        image_files = [
            f for f in files if f.lower().endswith((".png", ".jpg", ".jpeg"))
        ]
        image_files = [
            f
            for f in image_files
            if os.path.exists(
                os.path.join(
                    self.dataset_dir, f"{os.path.splitext(f)[0]}{self.caption_ext}"
                )
            )
        ]
        return sorted(image_files)

    def load_image_and_caption(self, index):
        """Load the image and corresponding caption at the specified index."""
        image_file = self.image_files[index]
        image_path = os.path.join(self.dataset_dir, image_file)
        caption_path = os.path.join(
            self.dataset_dir, f"{os.path.splitext(image_file)[0]}{self.caption_ext}"
        )

        # Load original image pixbuf
        try:
            self.original_pixbuf = GdkPixbuf.Pixbuf.new_from_file(image_path)
            # Clear the current image until it's scaled by the size-allocate handler
            self.image.set_from_pixbuf(None)
            # Manually trigger a size-allocate to scale the new image
            self.image.queue_resize()
        except gi.repository.GLib.Error as e:
            print(f"Error loading image {image_path}: {e}")
            self.original_pixbuf = None
            self.image.set_from_pixbuf(None) # Ensure no old image is displayed
            self.caption_label.set_text(f"Error loading image: {e}")
            return # Stop loading caption if image failed

        # Load caption
        try:
            with open(caption_path, "r") as f:
                caption = f.read().strip()
            self.caption_label.set_text(caption)
        except FileNotFoundError:
            self.caption_label.set_text("[No caption found]")
        except Exception as e:
            self.caption_label.set_text(f"[Error loading caption: {e}]")


    def _scale_and_display_image(self, widget, allocation):
        """Scales the original pixbuf to fit the allocated size and displays it."""
        if self.original_pixbuf is None or allocation.width <= 0 or allocation.height <= 0:
            return

        original_width = self.original_pixbuf.get_width()
        original_height = self.original_pixbuf.get_height()
        allocated_width = allocation.width
        allocated_height = allocation.height

        # Calculate scaling factors
        width_scale = allocated_width / original_width
        height_scale = allocated_height / original_height

        # Use the minimum scale factor to fit within the allocated area while preserving aspect ratio
        scale_factor = min(width_scale, height_scale)

        # Calculate target dimensions
        target_width = int(original_width * scale_factor)
        target_height = int(original_height * scale_factor)

        # Scale the original pixbuf
        scaled_pixbuf = self.original_pixbuf.scale_simple(
            target_width,
            target_height,
            GdkPixbuf.InterpType.BILINEAR # Good quality interpolation
        )

        # Set the scaled pixbuf to the image widget
        self.image.set_from_pixbuf(scaled_pixbuf)


    def edit_caption(self):
        """Open the current caption file with the default text editor."""
        if not self.image_files:
            return

        image_file = self.image_files[self.current_index]
        caption_path = os.path.join(
            self.dataset_dir, f"{os.path.splitext(image_file)[0]}{self.caption_ext}"
        )
        try:
            # Use a more robust way to open files cross-platform if needed,
            # but xdg-open is standard on many Linux systems.
            subprocess.run(["xdg-open", caption_path])
        except FileNotFoundError:
            print(f"Error: 'xdg-open' command not found. Cannot open {caption_path}.")
        except Exception as e:
            print(f"Error launching editor for {caption_path}: {e}")

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Right:
            self.next_image()
        elif event.keyval == Gdk.KEY_Left:
            self.prev_image()
        elif event.keyval == Gdk.KEY_Return:
            self.edit_caption()
        elif event.keyval == Gdk.KEY_Escape:
            Gtk.main_quit()

    def next_image(self):
        if self.current_index < len(self.image_files) - 1:
            self.current_index += 1
            self.load_image_and_caption(self.current_index)

    def prev_image(self):
        if self.current_index > 0:
            self.current_index -= 1
            self.load_image_and_caption(self.current_index)


def main():
    if len(sys.argv) < 2:
        print("Usage: dataset-viewer <dataset_directory> [caption_extension]")
        sys.exit(1)

    dataset_dir = sys.argv[1]
    caption_ext = sys.argv[2] if len(sys.argv) > 2 else ".txt"

    if not os.path.isdir(dataset_dir):
        print(f"Error: {dataset_dir} is not a valid directory.")
        sys.exit(1)

    app = ImageCaptionViewer(dataset_dir, caption_ext)
    app.connect("destroy", Gtk.main_quit)
    app.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()