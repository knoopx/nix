#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 -p python3Packages.pygobject3 -p python312Packages.markdown2 -p gtksourceview5 -p libadwaita -p webkitgtk_6_0

import os
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("GtkSource", "5")
gi.require_version("Adw", "1")
gi.require_version("WebKit", "6.0")
from gi.repository import Gtk, GtkSource, Gdk, Pango, Adw, WebKit, GLib
from markdown2 import markdown
import urllib.parse

NOTES_DIR = os.path.expanduser("~/Documents")
EXT = ".md"

# CSS for WebView
PREVIEW_CSS = """
body {
    font-family: sans-serif;
    line-height: 1.6;
    padding: 20px;
    margin: 0;
    background-color: #1e1e2e;
    color: #cdd6f4;
}
pre {
    padding: 10px;
    border-radius: 5px;
}
code {
    font-family: monospace;
    padding: 2px 4px;
    border-radius: 3px;
}

a {
    color: #b4befe;
}
"""


class NotesApp(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="Markdown Notes")
        self.set_default_size(800, 600)

        # Setup AdwHeaderBar
        self.header = Adw.HeaderBar()

        # Move search entry to header bar
        self.entry = Gtk.SearchEntry()
        self.entry.set_hexpand(True)

        self.entry.set_placeholder_text("Search or create note...")
        self.entry.connect("activate", self.on_entry_activate)
        self.entry.connect("search-changed", self.on_entry_changed)
        self.header.set_title_widget(self.entry)

        self.notes = []
        self.filtered_notes = []
        self.current_note_path = None
        self.is_editing = False
        self.load_notes()

        self.create_ui()
        self.setup_shortcuts()

        # Add focus controller for text entry shortcut
        key_controller = Gtk.EventControllerKey.new()
        key_controller.connect("key-pressed", self.on_window_key_press)
        self.add_controller(key_controller)

        self.entry.grab_focus()

    def create_ui(self):
        # Main layout with headerbar
        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(main_box)
        main_box.append(self.header)

        # Use Adw.OverlaySplitView for sidebar and content
        self.split_view = Adw.OverlaySplitView()
        self.split_view.set_vexpand(True)
        self.split_view.set_hexpand(True)
        self.vbox_sidebar_content = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL, spacing=10
        )
        # self.vbox_sidebar_content.set_hexpand(False)
        main_box.append(self.split_view)

        # Notes List
        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_vexpand(True)
        self.vbox_sidebar_content.append(scrolled_window)

        self.note_list = Gtk.ListBox()
        self.note_list.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self.note_list.connect("row-selected", self.on_note_selected)
        scrolled_window.set_child(self.note_list)

        # Set the sidebar child of the SplitView
        self.split_view.set_sidebar(self.vbox_sidebar_content)

        # Content Area - Stack to switch between edit and preview
        self.content_stack = Gtk.Stack()
        self.content_stack.set_hexpand(True)
        self.content_stack.set_vexpand(True)

        # Source view with language manager for markdown highlighting
        edit_scroll = Gtk.ScrolledWindow()
        lang_manager = GtkSource.LanguageManager()
        buffer = GtkSource.Buffer()
        markdown_lang = lang_manager.get_language("markdown")
        if markdown_lang:
            buffer.set_language(markdown_lang)

        self.content_view = GtkSource.View(buffer=buffer)
        self.content_view.set_wrap_mode(Gtk.WrapMode.WORD)
        self.content_view.set_monospace(True)
        self.content_buffer = self.content_view.get_buffer()
        edit_scroll.set_child(self.content_view)

        # Create WebView for preview
        preview_scroll = Gtk.ScrolledWindow()
        self.webview = WebKit.WebView()
        self.webview.set_vexpand(True)
        self.webview.set_hexpand(True)
        # Connect to the decide-policy signal
        self.webview.connect("decide-policy", self.on_webview_decide_policy)
        preview_scroll.set_child(self.webview)

        # Add pages to stack
        self.content_stack.add_titled(edit_scroll, "edit", "Edit")
        self.content_stack.add_titled(preview_scroll, "preview", "Preview")

        # Default to preview mode
        self.content_stack.set_visible_child_name("preview")

        # Set the content child of the SplitView
        self.split_view.set_content(self.content_stack)

        # Add sidebar toggle button to the header bar
        self.sidebar_button = Gtk.Button()
        # self.sidebar_button.set_icon_name("sidebar-show-symbolic")
        self.sidebar_button.set_child(Gtk.Image.new_from_icon_name("sidebar-show-symbolic"))
        self.sidebar_button.set_tooltip_text("Toggle Sidebar (Ctrl+B)")
        self.sidebar_button.connect("clicked", self.on_sidebar_button_clicked)
        self.header.pack_start(self.sidebar_button)

        # Connect to the 'show-sidebar' property to update the button icon
        # self.split_view.connect("notify::show-sidebar", self.update_sidebar_button_icon)

        # Add click and key controllers
        click_gesture = Gtk.GestureClick()
        click_gesture.set_button(1)  # Left mouse button
        click_gesture.connect("pressed", self.on_content_double_click)
        self.webview.add_controller(click_gesture)

        key_controller = Gtk.EventControllerKey()
        key_controller.connect("key-pressed", self.on_key_press)
        self.content_view.add_controller(key_controller)

        # Focus controller for edit mode
        focus_controller = Gtk.EventControllerFocus()
        focus_controller.connect("leave", self.on_editor_focus_lost)
        self.content_view.add_controller(focus_controller)

        self.refresh_note_list()

    def setup_shortcuts(self):
        # Shortcut for toggling sidebar (Ctrl+B)
        shortcut_controller = Gtk.ShortcutController.new()
        toggle_sidebar_shortcut = Gtk.Shortcut.new(
            Gtk.ShortcutTrigger.parse_string("<control>b"),
            Gtk.CallbackAction.new(self.toggle_sidebar, None),
        )
        shortcut_controller.add_shortcut(toggle_sidebar_shortcut)
        self.add_controller(shortcut_controller)

    def find_notes_recursively(self, directory):
        """Find all markdown files recursively starting from directory"""
        notes = []
        for root, dirs, files in os.walk(directory):
            for file in files:
                if file.endswith(EXT):
                    # Store relative path from NOTES_DIR
                    rel_path = os.path.relpath(os.path.join(root, file), NOTES_DIR)
                    notes.append(rel_path)
        return notes

    def load_notes(self):
        self.notes = self.find_notes_recursively(NOTES_DIR)

    def refresh_note_list(self):
        # Remove all children from the list box
        while True:
            row = self.note_list.get_first_child()
            if row is None:
                break
            self.note_list.remove(row)

        # Filter and sort notes
        search_text = self.entry.get_text().lower()
        self.filtered_notes = [
            note for note in self.notes if search_text in note.lower()
        ]
        self.filtered_notes.sort(key=lambda x: (-len(x.split("/")), *x.split("/")))

        for note in self.filtered_notes:
            row = Gtk.ListBoxRow()

            # Strip the file extension for display
            display_name = os.path.splitext(note)[0]

            label = Gtk.Label(label=display_name)
            label.set_ellipsize(Pango.EllipsizeMode.END)
            label.set_max_width_chars(80)
            label.set_xalign(0)
            label.set_margin_start(5)
            label.set_margin_end(5)
            label.set_margin_top(5)
            label.set_margin_bottom(5)

            # Store the actual filename with extension as a Python attribute
            row.filename = note

            row.set_child(label)
            self.note_list.append(row)

    def on_entry_activate(self, entry):
        query = entry.get_text().strip()
        if not query:
            return

        # Add extension if not already present
        if not query.lower().endswith(EXT):
            filename = query + EXT
        else:
            filename = query
            query = os.path.splitext(query)[0]

        # Normalize filename to be relative path from NOTES_DIR
        filename_relative = os.path.relpath(
            os.path.join(NOTES_DIR, filename), NOTES_DIR
        )

        matching_notes = [
            note for note in self.notes if filename_relative.lower() == note.lower()
        ]
        if not matching_notes:
            new_note_path = os.path.join(NOTES_DIR, filename)
            os.makedirs(os.path.dirname(new_note_path), exist_ok=True)
            initial_content = f"# {query}\n\n"
            with open(new_note_path, "w") as f:
                f.write(initial_content)
            self.notes.append(filename_relative)
            self.notes.sort()
            self.refresh_note_list()

            # Select the newly created note
            for i, note in enumerate(self.filtered_notes):
                if note == filename_relative:
                    row = self.note_list.get_row_at_index(i)
                    if row:
                        self.note_list.select_row(row)
                    break
        else:
            # If a matching note exists, select it
            for i, note in enumerate(self.filtered_notes):
                if note == matching_notes[0]:
                    row = self.note_list.get_row_at_index(i)
                    if row:
                        self.note_list.select_row(row)
                    break

        entry.set_text("")

    def on_entry_changed(self, entry):
        self.refresh_note_list()

    def on_note_selected(self, listbox, row):
        if row and hasattr(row, "filename"):
            note_name = row.filename
            self.current_note_path = os.path.join(NOTES_DIR, note_name)
            self.load_note()
            # Hide the sidebar on narrow widths after selecting a note if hide mode is active
            if (
                hasattr(self.split_view, "get_hide_sidebar")
                and self.split_view.get_hide_sidebar()
            ):
                self.split_view.set_show_sidebar(False)

    def load_note(self):
        if self.current_note_path and os.path.exists(self.current_note_path):
            with open(self.current_note_path, "r") as f:
                content = f.read()

            if self.is_editing:
                self.content_buffer.set_text(content)
                self.content_stack.set_visible_child_name("edit")
            else:
                html_content = f"""
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>{PREVIEW_CSS}</style>
                </head>
                <body>
                    {markdown(content, extras=["fenced-code-blocks", "tables", "nofollow"])}
                </body>
                </html>
                """
                self.webview.load_html(html_content, "file:///")
                self.content_stack.set_visible_child_name("preview")
        else:
            self.current_note_path = None
            self.content_buffer.set_text("")
            self.webview.load_html("", "file:///")
            self.content_stack.set_visible_child_name("preview")
            self.load_notes()
            self.refresh_note_list()

    def save_note_content(self):
        if self.current_note_path:
            start_iter = self.content_buffer.get_start_iter()
            end_iter = self.content_buffer.get_end_iter()
            content = self.content_buffer.get_text(start_iter, end_iter, True)

            os.makedirs(os.path.dirname(self.current_note_path), exist_ok=True)

            with open(self.current_note_path, "w") as f:
                f.write(content)

    def on_content_double_click(self, gesture, n_press, x, y):
        if n_press == 2:
            self.enter_edit_mode()

    def enter_edit_mode(self):
        self.is_editing = True
        if self.current_note_path and os.path.exists(self.current_note_path):
            with open(self.current_note_path, "r") as f:
                content = f.read()
            self.content_buffer.set_text(content)
            self.content_stack.set_visible_child_name("edit")
            self.content_view.grab_focus()
        else:
            self.content_buffer.set_text("")
            self.content_stack.set_visible_child_name("edit")
            self.content_view.grab_focus()

    def exit_edit_mode(self):
        if self.is_editing:
            self.is_editing = False
            self.save_note_content()
            self.load_note()

    def on_editor_focus_lost(self, controller):
        # Basic focus lost save. Could be refined if needed.
        self.exit_edit_mode()

    def on_key_press(self, controller, keyval, keycode, state, user_data=None):
        if keyval == Gdk.KEY_Escape and self.is_editing:
            self.exit_edit_mode()
            return True
        return False

    def on_window_key_press(self, controller, keyval, keycode, state, user_data=None):
        if keyval == Gdk.KEY_slash and state & Gdk.ModifierType.CONTROL_MASK:
            self.entry.grab_focus()
            return True
        return False

    def on_sidebar_button_clicked(self, button):
        self.toggle_sidebar()

    def toggle_sidebar(self, *args):
        """Toggles the visibility of the sidebar using Adw.OverlaySplitView."""
        is_visible = self.split_view.get_show_sidebar()
        self.split_view.set_show_sidebar(not is_visible)


    def on_webview_decide_policy(self, webview, decision, decision_type):
        """Handle navigation policy decisions, opening external links externally."""
        if decision_type == WebKit.PolicyDecisionType.NAVIGATION_ACTION:
            navigation_action = decision.get_navigation_action()
            request = navigation_action.get_request()
            uri = request.get_uri()

            # Check if it's a link click and not a local file URI
            if (
                navigation_action.get_navigation_type()
                == WebKit.NavigationType.LINK_CLICKED
            ):
                parsed_uri = urllib.parse.urlparse(uri)
                if parsed_uri.scheme in ["http", "https", "mailto", "ftp"]:
                    try:
                        # Use Gtk.show_uri to open in the default external browser
                        # Pass the main window as the parent for better dialog parenting
                        Gtk.show_uri(self, uri, Gdk.CURRENT_TIME)
                        # Ignore the navigation in the webview
                        decision.ignore()
                        return True
                    except GLib.Error as e:
                        print(f"Failed to open URI {uri}: {e}")
                        # Let webview handle it if external opening fails or is unsupported
                        decision.use()
                        return False

        # For other types of decisions or non-external links, use the default policy
        decision.use()
        return False


class NotesApplication(Adw.Application):
    def __init__(self):
        super().__init__(application_id="com.example.markdown_notes")
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        window = NotesApp(app)
        window.present()


def main():
    os.makedirs(NOTES_DIR, exist_ok=True)
    app = NotesApplication()
    return app.run(None)


if __name__ == "__main__":
    main()
