#!/usr/bin/env python3
import gi
import os
import json
import tempfile
import threading

gi.require_version('Gtk', '4.0')
gi.require_version('WebKit', '6.0')
gi.require_version('Adw', '1')

from gi.repository import Gtk, WebKit, GLib, Gio, Adw, GObject

class MDXEditorWidget(Gtk.Box):
    __gtype_name__ = 'MDXEditorWidget'

    def __init__(self):
        super().__init__(orientation=Gtk.Orientation.VERTICAL)
        self.set_hexpand(True)
        self.set_vexpand(True)

        # Setup markdown property
        self._markdown = ""

        # Register JavaScript handlers
        self.content_manager = WebKit.UserContentManager()
        self.content_manager.register_script_message_handler("markdownChanged", None)
        self.content_manager.register_script_message_handler("editorReady", None)
        self.content_manager.connect("script-message-received::markdownChanged", self.on_markdown_changed)
        self.content_manager.connect("script-message-received::editorReady", self.on_editor_ready)

        # Create WebView with content manager
        self.web_view = WebKit.WebView.new_with_user_content_manager(self.content_manager)
        self.web_view.set_hexpand(True)
        self.web_view.set_vexpand(True)

        # Enable JavaScript
        settings = self.web_view.get_settings()
        settings.set_enable_javascript(True)
        settings.set_enable_developer_extras(True)

        # Create HTML file with MDXEditor in a temporary directory
        self.temp_dir = tempfile.TemporaryDirectory()
        self.html_path = os.path.join(self.temp_dir.name, "editor.html")
        self.create_html_file()

        # Load the HTML file
        file_uri = f"file://{self.html_path}"
        self.web_view.load_uri(file_uri)

        # Connect load-changed signal
        self.web_view.connect("load-changed", self.on_load_changed)

        # Add WebView to the Box
        self.append(self.web_view)

    def create_html_file(self):
        html_content = """<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MDXEditor</title>
    <script src="https://unpkg.com/react@18.2.0/umd/react.production.min.js"></script>
    <script src="https://unpkg.com/react-dom@18.2.0/umd/react-dom.production.min.js"></script>
    <script src="https://unpkg.com/@mdxeditor/editor@1.11.1/dist/mdxeditor.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/@mdxeditor/editor@1.11.1/dist/style.css">
    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            width: 100%;
            overflow: hidden;
        }
        #editor-container {
            height: 100vh;
            width: 100%;
        }
    </style>
</head>
<body>
    <div id="editor-container"></div>
    <script>
        const { MDXEditor, UndoRedo, BoldItalicUnderlineToggles,
                CodeToggle, CreateLink, DiffSourceToggleWrapper,
                InsertImage, InsertThematicBreak, ListsToggle,
                BlockTypeSelect, Separator, ConditionalContents } = MDXEditorComponents;

        let editorInstance = null;

        function initEditor(initialMarkdown = '') {
            const root = ReactDOM.createRoot(document.getElementById('editor-container'));

            root.render(
                React.createElement(MDXEditor, {
                    markdown: initialMarkdown,
                    onChange: (markdown) => {
                        window.webkit.messageHandlers.markdownChanged.postMessage(markdown);
                    },
                    contentEditableClassName: "mdx-editor-content",
                    plugins: [
                        UndoRedo(),
                        BoldItalicUnderlineToggles(),
                        CodeToggle(),
                        CreateLink(),
                        ListsToggle(),
                        BlockTypeSelect(),
                        InsertThematicBreak(),
                        InsertImage({
                            imageUploadHandler: async (file) => {
                                // This is a placeholder URL since we can't upload files in this example
                                return URL.createObjectURL(file);
                            }
                        }),
                        DiffSourceToggleWrapper({
                            diffMarkdown: initialMarkdown,
                            viewMode: "rich-text",
                        }),
                    ],
                })
            );

            // Store reference to the editor instance
            editorInstance = document.querySelector('.mdx-editor');
        }

        // Function to update editor content from Python
        function setMarkdown(markdown) {
            if (editorInstance) {
                // Get the MDXEditor component instance
                const editorComponent = Object.keys(editorInstance).find(key =>
                    key.startsWith('__reactFiber$') || key.startsWith('__reactInternalInstance$')
                );

                if (editorComponent) {
                    const fiber = editorInstance[editorComponent];
                    if (fiber && fiber.return && fiber.return.stateNode) {
                        // Update the editor content
                        fiber.return.stateNode.setMarkdown(markdown);
                        return true;
                    }
                }
            }
            return false;
        }

        // Initialize editor when the page loads
        document.addEventListener('DOMContentLoaded', () => {
            initEditor('');

            // Signal to GTK that we're ready
            window.webkit.messageHandlers.editorReady.postMessage('ready');
        });
    </script>
</body>
</html>
"""
        with open(self.html_path, "w") as f:
            f.write(html_content)

    def on_load_changed(self, web_view, load_event):
        if load_event == WebKit.LoadEvent.FINISHED:
            # Content is loaded, we can now interact with the editor
            pass

    def on_markdown_changed(self, content_manager, js_result):
        # Update the markdown property when content changes in the editor
        self._markdown = js_result.get_js_value().to_string()
        self.notify("markdown")

    def on_editor_ready(self, content_manager, js_result):
        # Editor is ready, we can set initial markdown if needed
        if self._markdown:
            self.set_markdown(self._markdown)

    def _js_callback(self, webview, result, user_data):
        try:
            js_result = webview.evaluate_javascript_finish(result)
            if js_result:
                # Handle result if needed
                pass
        except Exception as e:
            print(f"Error executing JavaScript: {e}")

    def set_markdown(self, markdown):
        self._markdown = markdown
        # Update the editor content
        js_code = f'setMarkdown({json.dumps(markdown)});'
        self.web_view.evaluate_javascript(js_code, -1, None, None, self._js_callback, None)

    def get_markdown(self):
        return self._markdown

    # Define markdown property
    markdown = GObject.Property(type=str, default="", getter=get_markdown, setter=set_markdown)


class MDXEditorApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="org.example.mdxeditor",
                         flags=Gio.ApplicationFlags.FLAGS_NONE)
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
        sample_markdown = """# MDX Editor Example

This is a **bold text** and *italic text*.

## Features
- Markdown editing
- Real-time preview
- Formatting tools

```python
def hello_world():
    print("Hello, GTK4 MDX Editor!")
```

> This is a blockquote

[Visit MDX Editor Docs](https://mdxeditor.dev/editor/docs/getting-started)
"""
        self.editor.set_markdown(sample_markdown)


if __name__ == "__main__":
    app = MDXEditorApp()
    app.run(None)