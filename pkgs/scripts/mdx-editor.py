#!/usr/bin/env python3
import gi
import os
import json
import tempfile
import threading

gi.require_version("Gtk", "4.0")
gi.require_version("WebKit", "6.0")
gi.require_version("Adw", "1")

from gi.repository import Gtk, WebKit, GLib, Gio, Adw, GObject


class MDXEditorWidget(Gtk.Box):
    __gtype_name__ = "MDXEditorWidget"

    def __init__(self):
        super().__init__(orientation=Gtk.Orientation.VERTICAL)
        self.set_hexpand(True)
        self.set_vexpand(True)

        # Setup markdown property
        self._markdown = ""

        # Create WebView with content manager
        self.web_view = WebKit.WebView.new()
        self.web_view.set_hexpand(True)
        self.web_view.set_vexpand(True)

        self.content_manager = self.web_view.get_user_content_manager()
        self.content_manager.register_script_message_handler("markdownChanged", None)
        self.content_manager.register_script_message_handler("editorReady", None)
        self.content_manager.connect(
            "script-message-received::markdownChanged", self.on_markdown_changed
        )
        self.content_manager.connect(
            "script-message-received::editorReady", self.on_editor_ready
        )

        # Enable JavaScript and developer tools
        settings = self.web_view.get_settings()
        settings.set_enable_javascript(True)
        settings.set_enable_developer_extras(True)
        settings.set_enable_write_console_messages_to_stdout(True)
        settings.set_property("allow-universal-access-from-file-urls", True)
        settings.set_property("allow-file-access-from-file-urls", True)

        # Create HTML file with MDXEditor in a temporary directory
        self.temp_dir = tempfile.TemporaryDirectory()
        self.html_path = os.path.join(os.path.dirname(__file__), "index.html")

        print(f"Loading HTML from: {self.html_path}")
        # Load the HTML file
        file_uri = f"file://{self.html_path}"
        self.web_view.load_uri(file_uri)

        # Connect load-changed signal
        self.web_view.connect("load-changed", self.on_load_changed)

        # Setup WebKit error logging
        self.web_view.connect("web-process-terminated", self.on_web_process_terminated)
        self.web_view.connect("load-failed", self.on_load_failed)

        # Add WebView to the Box
        self.append(self.web_view)

    def on_load_changed(self, web_view, load_event):
        if load_event == WebKit.LoadEvent.FINISHED:
            # Content is loaded, we can now interact with the editor
            pass

    def on_markdown_changed(self, content_manager, js_result):
        # Update the markdown property when content changes in the editor
        self._markdown = js_result.to_string()
        self.notify("markdown")

    def on_editor_ready(self, content_manager, js_result):
        # Editor is ready, we can set initial markdown if needed
        if self._markdown:
            self.set_markdown(self._markdown)

    def _js_callback(self, source_object, result, user_data=None):
        try:
            js_result = self.web_view.evaluate_javascript_finish(result)
            if js_result:
                # Handle result if needed
                pass
        except Exception as e:
            print(f"Error executing JavaScript: {e}")

    def set_markdown(self, markdown):
        self._markdown = markdown
        # Update the editor content with proper callback
        js_code = f"setMarkdown({json.dumps(markdown)});"
        self.web_view.evaluate_javascript(
            js_code, -1, None, None, None, self._js_callback
        )  # Remove lambda, use method directly

    def get_markdown(self):
        return self._markdown

    # Define markdown property
    markdown = GObject.Property(
        type=str, default="", getter=get_markdown, setter=set_markdown
    )

    # Add new error handling methods
    def on_web_process_terminated(self, web_view, reason):
        print(f"WebKit process terminated: {reason}")

    def on_load_failed(self, web_view, load_event, failing_uri, error):
        print(f"Load failed: {failing_uri}, Error: {error}")


class MDXEditorApp(Adw.Application):
    def __init__(self):
        super().__init__(
            application_id="org.example.mdxeditor",
            flags=Gio.ApplicationFlags.FLAGS_NONE,
        )
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        # Create the main window
        self.win = Adw.ApplicationWindow(application=app)
        self.win.set_default_size(800, 600)
        self.win.set_title("MDX Editor")

        # Create a header bar
        header = Adw.HeaderBar()

        # Create a box for the main content
        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)

        # Create MDXEditor widget
        self.editor = MDXEditorWidget()

        # Add the header bar and editor to the main box
        main_box.append(header)
        main_box.append(self.editor)

        # Set the main box as the content of the window
        self.win.set_content(main_box)

        # Add some example buttons to demonstrate the API
        get_button = Gtk.Button(label="Get Markdown")
        get_button.connect("clicked", self.on_get_markdown)
        header.pack_start(get_button)

        set_button = Gtk.Button(label="Set Sample Markdown")
        set_button.connect("clicked", self.on_set_markdown)
        header.pack_start(set_button)

        # Show the window
        self.win.present()

    def on_get_markdown(self, button):
        markdown = self.editor.get_markdown()
        print(f"Current Markdown:\n{markdown}")

        # Show in a dialog
        dialog = Adw.MessageDialog(
            transient_for=self.win,
            heading="Current Markdown",
            body=markdown or "(empty)",
        )
        dialog.add_response("close", "Close")
        dialog.present()

    def on_set_markdown(self, button):
        sample_markdown = """# Welcome

This is a **live demo** of MDXEditor with all default features on.

> The overriding design goal for Markdown’s formatting syntax is to make it as readable as possible.
> The idea is that a Markdown-formatted document should be publishable as-is, as plain text,
> without looking like it’s been marked up with tags or formatting instructions.

[— Daring Fireball](https://daringfireball.net/projects/markdown/).

In here, you can find the following markdown elements:

* Headings
* Lists
  * Unordered
  * Ordered
  * Check lists
  * And nested ;)
* Links
* Bold/Italic/Underline formatting
* Tables
* Code block editors
* And much more.

The current editor content is styled using the `@tailwindcss/typography` [plugin](https://tailwindcss.com/docs/typography-plugin).

## What can you do here?

This is a great location for you to test how editing markdown feels. If you have an existing markdown source, you can switch to source mode using the toggle group in the top right, paste it in there, and go back to rich text mode.

If you need a few ideas, here's what you can try:

1. Add your own code sample
2. Change the type of the headings
3. Insert a table, add a few rows and columns
4. Switch back to source markdown to see what you're going to get as an output
5. Test the diff feature to see how the markdown has changed
6. Add a frontmatter block through the toolbar button

## A code sample

MDXEditor embeds CodeMirror for code editing.

```tsx
export default function App() {
  return (<div>Hello world</div>)
}
```

## A live code example

The block below is a live React component. You can configure multiple live code presets that specify the available npm packages and the default imports. You can also specify a default component that will be rendered in the live code block.

```jsx live
export default function App() {
  return (<div>
  <p>This is a live React component, that's being previewed in codesandbox. </p>
  <p>Editing it will update the fenced codeblock in the markdown.</p>
  </div>)
}
```

## A table

Play with the table below - add rows, columns, change column alignment. When editing,
you can navigate the cells with `enter`, `shift+enter`, `tab` and `shift+tab`.

| Item              | In Stock | Price |
| :---------------- | :------: | ----: |
| Python Hat        |   True   | 23.99 |
| SQL Hat           |   True   | 23.99 |
| Codecademy Tee    |   False  | 19.99 |
| Codecademy Hoodie |   False  | 42.99 |
"""
        self.editor.set_markdown(sample_markdown)


if __name__ == "__main__":
    app = MDXEditorApp()
    app.run(None)
