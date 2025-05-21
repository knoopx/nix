#!/usr/bin/env python

import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, Adw, Gio, Gdk, GLib

import os
import json
from pathlib import Path


class AppHistory:
    def __init__(self):
        # Use XDG_DATA_HOME or fallback to ~/.local/share
        data_home = os.environ.get(
            "XDG_DATA_HOME", os.path.expanduser("~/.local/share")
        )
        self.data_file = Path(data_home) / "launcher" / "history.json"
        self.launch_counts = self._load_history()

    def _load_history(self):
        try:
            self.data_file.parent.mkdir(parents=True, exist_ok=True)
            if self.data_file.exists():
                with open(self.data_file, "r") as f:
                    return json.load(f)
        except Exception:
            pass
        return {}

    def _save_history(self):
        try:
            with open(self.data_file, "w") as f:
                json.dump(self.launch_counts, f)
        except Exception:
            pass

    def record_launch(self, app_id):
        self.launch_counts[app_id] = self.launch_counts.get(app_id, 0) + 1
        self._save_history()

    def get_launch_count(self, app_id):
        return self.launch_counts.get(app_id, 0)


class LauncherWindow(Adw.ApplicationWindow):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.app_history = AppHistory()

        # Setup window
        self.set_default_size(500, 900)
        self.set_title("Applications")

        # Main box
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(box)

        # Header with search
        header = Adw.HeaderBar()
        self.search_entry = Gtk.SearchEntry()
        self.search_entry.set_hexpand(True)
        header.set_title_widget(self.search_entry)
        box.append(header)

        # Add key controller for search entry
        key_controller = Gtk.EventControllerKey()
        key_controller.connect("key-pressed", self.on_key_press)
        self.search_entry.add_controller(key_controller)

        # Apps list
        self.list_box = Gtk.ListBox()
        self.list_box.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self.list_box.set_activate_on_single_click(True)
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_vexpand(True)
        scrolled.set_child(self.list_box)
        self.scrolled = scrolled  # Store reference to scrolled window
        box.append(scrolled)

        # Load apps and setup signals
        self.load_apps()
        self.search_entry.connect("search-changed", self.on_search_changed)
        self.search_entry.connect("activate", self.on_search_activate)
        self.list_box.connect("row-activated", self.on_row_activated)
        self.connect("close-request", self.on_close_request)

        # Add window event controller for activation
        window_controller = Gtk.EventControllerFocus()
        window_controller.connect("enter", self.on_window_activate)
        self.add_controller(window_controller)

        # Connect map signal for initial focus
        self.connect("map", self.on_window_map)

    def on_window_map(self, window):
        self.search_entry.grab_focus()

    def load_apps(self):
        self.apps = []
        # Collect apps and sort by launch frequency and name
        unsorted_apps = [
            app_info for app_info in Gio.AppInfo.get_all() if app_info.should_show()
        ]
        sorted_apps = sorted(
            unsorted_apps,
            key=lambda app: (
                -self.app_history.get_launch_count(app.get_id()),
                app.get_name().lower(),
            ),
        )

        for app_info in sorted_apps:
            self.apps.append(app_info)
            row = Gtk.ListBoxRow()
            box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
            box.set_margin_start(10)
            box.set_margin_end(10)
            box.set_margin_top(5)
            box.set_margin_bottom(5)

            icon = Gtk.Image.new_from_gicon(app_info.get_icon())
            icon.set_pixel_size(32)
            box.append(icon)

            label = Gtk.Label(label=app_info.get_name())
            label.set_halign(Gtk.Align.START)
            box.append(label)

            row.set_child(box)
            row.app_info = app_info
            self.list_box.append(row)

    def on_search_changed(self, entry):
        search_text = entry.get_text().lower()
        current_selected = self.list_box.get_selected_row()

        # Update visibility of all rows
        for row in self.list_box:
            app_name = row.app_info.get_name().lower()
            row.set_visible(search_text in app_name)

        # If current selection is hidden or no selection, select first visible
        if not current_selected or not current_selected.get_visible():
            first_visible = self.find_next_visible_row(0, 1)
            if first_visible:
                self.list_box.select_row(first_visible)

    def on_key_press(self, controller, keyval, keycode, state):
        if keyval == Gdk.KEY_Up:
            self.move_selection(-1)
            return True
        elif keyval == Gdk.KEY_Down:
            self.move_selection(1)
            return True
        elif keyval == Gdk.KEY_Escape:
            self.close()
            return True
        return False

    def on_search_activate(self, entry):
        selected = self.list_box.get_selected_row()
        if selected:
            self.launch_app(selected.app_info)
        return True

    def scroll_to_row(self, row):
        adj = self.scrolled.get_vadjustment()
        if not adj:
            return

        # Get row dimensions
        row_height = row.get_allocated_height()
        row_y = row.get_allocation().y

        # Get visible area dimensions
        visible_height = self.scrolled.get_allocated_height()

        # Calculate visible area boundaries
        visible_top = adj.get_value()
        visible_bottom = visible_top + visible_height

        # If row is partially or fully outside visible area
        if row_y < visible_top or (row_y + row_height) > visible_bottom:
            # Center the row if possible
            target = row_y - (visible_height - row_height) / 2
            # Clamp the value between adjustment bounds
            target = max(0, min(target, adj.get_upper() - visible_height))
            adj.set_value(target)

    def move_selection(self, direction):
        selected = self.list_box.get_selected_row()
        start_index = (
            selected.get_index()
            if selected
            else (
                -1 if direction > 0 else self.list_box.observe_children().get_n_items()
            )
        )

        next_row = self.find_next_visible_row(start_index, direction)
        if next_row:
            self.list_box.select_row(next_row)
            self.scroll_to_row(next_row)

    def find_next_visible_row(self, start_index, direction):
        index = start_index + direction
        n_items = self.list_box.observe_children().get_n_items()
        while 0 <= index < n_items:
            row = self.list_box.get_row_at_index(index)
            if row and row.get_visible():
                return row
            index += direction
        return None

    def launch_app(self, app_info):
        self.app_history.record_launch(app_info.get_id())
        self.search_entry.set_text("")  # Clear search entry
        self.search_entry.emit("search-changed")  # Update list
        self.list_box.unselect_all()  # Clear selection

        try:
            context = self.get_display().get_app_launch_context()
            launched = app_info.launch_uris_as_manager(
                [], context, GLib.SpawnFlags.SEARCH_PATH, None, None
            )
            if not launched:
                print(f"Failed to launch {app_info.get_id()}")
        except Exception as e:
            print(f"Error launching {app_info.get_id()}: {str(e)}")

        self.close()

    def on_row_activated(self, list_box, row):
        self.launch_app(row.app_info)

    def on_close_request(self, window):
        # Hide instead of destroy
        self.set_visible(False)
        return True

    def on_window_activate(self, controller):
        # Select all text and move caret to end
        self.search_entry.select_region(0, -1)
        self.search_entry.set_position(-1)
        # Ensure first visible item is selected
        first_visible = self.find_next_visible_row(-1, 1)
        if first_visible:
            self.list_box.select_row(first_visible)
            self.scroll_to_row(first_visible)


class Launcher(Adw.Application):
    def __init__(self):
        super().__init__(
            application_id="net.knoopx.launcher",
            flags=Gio.ApplicationFlags.HANDLES_COMMAND_LINE,
        )
        self.window = None

    def do_startup(self):
        Adw.Application.do_startup(self)
        # Keep the application running
        self.hold()

    def do_activate(self):
        if not self.window:
            self.window = LauncherWindow(application=self)

        if self.window.get_visible():
            self.window.set_visible(False)
        else:
            self.window.present()

    def do_command_line(self, command_line):
        self.activate()
        return 0


if __name__ == "__main__":
    app = Launcher()
    app.run(None)
