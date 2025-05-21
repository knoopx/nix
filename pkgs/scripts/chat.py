#!/usr/bin/env python

import subprocess
import sys

import gi
import openai
import os
import threading

gi.require_version("Gdk", "4.0")
gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
gi.require_version("WebKit", "6.0")
from gi.repository import Gtk, GLib, Gdk, Adw, WebKit


client = openai.OpenAI(
    api_key=os.getenv("OPENAI_API_KEY"), base_url=os.getenv("OPENAI_API_BASE")
)


def markdown(markdown_content):
    proc = subprocess.Popen(
        ["md2html"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    stdout, stderr = proc.communicate(markdown_content)

    if proc.returncode != 0:
        raise RuntimeError(f"Error: {stderr.strip()}")

    return stdout.strip()


def markdown_async(markdown_content, callback):
    def worker():
        try:
            html = markdown(markdown_content)
            GLib.idle_add(lambda: callback(html))
        except Exception as e:
            print(f"Markdown rendering error: {e}")
            GLib.idle_add(lambda: callback(f"<pre>{markdown_content}</pre>"))

    thread = threading.Thread(target=worker)
    thread.daemon = True
    thread.start()


class OpenAIStreamer:
    def __init__(self, model=None):
        self.model = model
        self.history = []  # To store conversation history

    def add_message(self, role, content):
        self.history.append({"role": role, "content": content})

    def get_completion_stream(self, prompt, on_chunk_received, on_stream_end, on_error):
        if not client:
            on_error("OpenAI client not initialized. Check API key.")
            return

        self.add_message("user", prompt)
        messages_to_send = self.history.copy()

        def stream_worker():
            try:
                stream = client.chat.completions.create(
                    model=self.model, messages=messages_to_send, stream=True
                )
                assistant_response = ""
                for chunk in stream:
                    if chunk.choices:
                        content = chunk.choices[0].delta.content
                        if content:
                            assistant_response += content
                            GLib.idle_add(on_chunk_received, content)
                GLib.idle_add(on_stream_end, assistant_response)
            except openai.APIError as e:
                error_message = f"OpenAI API Error: {e}"
                print(error_message)
                GLib.idle_add(on_error, error_message)
            except Exception as e:
                error_message = f"An unexpected error occurred: {e}"
                print(error_message)
                GLib.idle_add(on_error, error_message)

        thread = threading.Thread(target=stream_worker)
        thread.daemon = True
        thread.start()


class ChatAppWindow(Gtk.ApplicationWindow):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.streamer = OpenAIStreamer()
        self.current_assistant_message = ""
        self.current_assistant_webview = None  # Add this attribute to store the webview reference

        self.set_default_size(600, 700)
        self.set_title("Chat")

        # Setup CSS provider for styling
        self.setup_css()

        # Main layout container
        self.main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_child(self.main_box)

        # Chat messages area with scrolling
        self.scrolled_window = Gtk.ScrolledWindow()
        self.scrolled_window.set_hexpand(True)
        self.scrolled_window.set_vexpand(True)
        self.scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)

        # Message list container
        self.messages_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        self.messages_box.set_margin_start(10)
        self.messages_box.set_margin_end(10)
        self.messages_box.set_margin_top(10)
        self.messages_box.set_margin_bottom(10)

        viewport = Gtk.Viewport()
        viewport.set_child(self.messages_box)
        self.scrolled_window.set_child(viewport)

        self.main_box.append(self.scrolled_window)

        # Input area
        input_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        input_box.set_margin_start(10)
        input_box.set_margin_end(10)
        input_box.set_margin_top(10)
        input_box.set_margin_bottom(10)

        self.input_entry = Gtk.Entry()
        self.input_entry.set_hexpand(True)
        self.input_entry.set_placeholder_text("Type your message...")
        self.input_entry.connect("activate", self.on_send_message)
        input_box.append(self.input_entry)

        send_button = Gtk.Button(label="Send")
        send_button.connect("clicked", self.on_send_message)
        send_button.add_css_class("suggested-action")
        input_box.append(send_button)

        self.main_box.append(input_box)
        self.input_entry.grab_focus()

    def setup_css(self):
        css_provider = Gtk.CssProvider()
        css = """
        .user-message, .assistant-message, .error-message {
            padding: 0 20px;
            border-radius: 4px;
        }
        .user-message { background-color: #181825; }
        .assistant-message { background-color: #313244; }
        .error-message { background-color: #f38ba8; }
        """
        css_provider.load_from_data(css.encode())
        Gtk.StyleContext.add_provider_for_display(
            self.get_display(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

    def add_message(self, text, className):
        web_view = WebKit.WebView()
        web_view.set_vexpand(False)
        web_view.set_hexpand(True)
        settings = web_view.get_settings()
        settings.set_enable_javascript(True)
        settings.set_enable_developer_extras(True)
        settings.set_enable_write_console_messages_to_stdout(True)
        settings.set_property("allow-universal-access-from-file-urls", True)
        settings.set_property("allow-file-access-from-file-urls", True)

        message_container = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        message_container.set_vexpand(False)
        message_container.set_hexpand(True)
        message_container.append(web_view)
        message_container.add_css_class(className)
        self.messages_box.append(message_container)

        web_view.connect("load-changed", self.on_load_changed)

        # Only load initial text if provided (e.g., for user messages or errors)
        # For streaming assistant messages, the content is loaded at the end
        if text:

            def on_markdown_complete(html_content):
                # Use "file:///" as the base URI
                web_view.load_html(html_content, "file:///")

            markdown_async(text, on_markdown_complete)

        rgba = Gdk.RGBA()
        rgba.parse("rgba(0,0,0,0)")
        web_view.set_background_color(rgba)
        return message_container

    def on_load_changed(self, web_view, event):
        if event == WebKit.LoadEvent.FINISHED:
            print("Load finished, querying height...")
            GLib.timeout_add(50, lambda: self.query_content_height(web_view))

    def query_content_height(self, web_view):
        # Pass the callback function and user data (self)
        web_view.evaluate_javascript(
            "Math.max(document.documentElement.scrollHeight, document.body.scrollHeight);",
            -1,  # length, -1 means null terminated
            None,  # world_name
            None,  # source_uri
            None,  # cancellable
            self._handle_height_result,  # callback function
            self,  # user_data
        )
        return False

    def _handle_height_result(self, web_view, async_result, user_data):
        # This is the actual callback function now, accepting standard async args
        try:
            # Get the actual result from the async_result
            js_value = web_view.evaluate_javascript_finish(async_result)

            # Check if the result is a number and get its integer value
            if js_value and js_value.is_number():
                height = int(js_value.to_double())  # Use to_double for safety, then int
                print(f"Got height from JS: {height}")
                # Use user_data to access the instance and call the method
                user_data.update_webview_height(web_view, height)
            else:
                print("Got non-numeric or null JS value")
                # Do not update height if value is invalid
                pass  # Removed default height fallback

        except Exception as e:
            print(f"Error getting height result: {e}")
            # Do not update height on error
            pass  # Removed default height fallback

    def update_webview_height(self, web_view, height):
        # Remove the minimum height constraint
        height_val = height
        web_view.set_size_request(-1, height_val)
        web_view.queue_resize()

    def scroll_to_bottom(self):
        adjustment = self.scrolled_window.get_vadjustment()
        adjustment.set_value(adjustment.get_upper() - adjustment.get_page_size())
        return False  # Required for GLib.idle_add

    def handle_stream_chunk(self, chunk):
        # Accumulate the message chunk by chunk
        if not self.current_assistant_message:
            self.current_assistant_message = chunk
            # Create the container and WebView on the first chunk
            self.current_message_container = self.add_message("", "assistant-message")
            self.current_assistant_webview = self.current_message_container.get_first_child()
        else:
            self.current_assistant_message += chunk

        def on_streaming_markdown_complete(html_content):
            if self.current_assistant_webview:
                self.current_assistant_webview.load_html(html_content, "file:///")
        markdown_async(self.current_assistant_message, on_streaming_markdown_complete)

        # Scroll to bottom on each chunk
        GLib.idle_add(self.scroll_to_bottom)

    def on_send_message(self, widget):
        if not client:
            self.add_message(
                "OpenAI client is not initialized. Cannot send message.",
                "error-message",
            )
            return

        prompt = self.input_entry.get_text()
        if not prompt.strip():
            return

        # Add user message immediately
        self.add_message(prompt, "user-message")
        self.input_entry.set_text("")
        self.input_entry.set_sensitive(False)

        # Reset assistant message state for the new response
        self.current_assistant_message = ""
        self.current_assistant_webview = None

        # Start the streaming process
        self.streamer.get_completion_stream(
            prompt,
            on_chunk_received=self.handle_stream_chunk,
            on_stream_end=self.handle_stream_end,
            on_error=self.handle_stream_error,
        )

    def handle_stream_end(self, full_assistant_response):
        # Add the complete message to history
        self.streamer.add_message("assistant", full_assistant_response)

        # Re-enable input and focus
        self.input_entry.set_sensitive(True)
        self.input_entry.grab_focus()

        # Now, render the full accumulated message and load it into the webview
        if self.current_assistant_webview and self.current_assistant_message:

            def on_final_markdown_complete(html_content):
                # Load the final HTML content into the webview
                # This already uses "file:///" as the base URI
                self.current_assistant_webview.load_html(html_content, "file:///")
                # The on_load_changed signal will be triggered by load_html
                # and will handle the height update based on the final content.

                # Clear the temporary webview reference and message string AFTER loading
                self.current_assistant_webview = None
                self.current_assistant_message = ""

            # Trigger markdown rendering for the complete message
            markdown_async(self.current_assistant_message, on_final_markdown_complete)

    def handle_stream_error(self, error_message):
        # Display the error message
        self.add_message(error_message, "error-message")

        # Re-enable input and focus
        self.input_entry.set_sensitive(True)
        self.input_entry.grab_focus()

        # Clear any partial state
        self.current_assistant_webview = None
        self.current_assistant_message = ""


class ChatApp(Adw.Application):
    def __init__(self, init_prompt=None, **kwargs):
        super().__init__(application_id="net.knoopx.chat", **kwargs)
        self.init_prompt = init_prompt
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        self.chat_window = ChatAppWindow(application=app)
        self.chat_window.present()
        if self.init_prompt:
            GLib.idle_add(self.handle_init_prompt)

    def handle_init_prompt(self):
        # Access the window via the instance stored in self
        self.chat_window.input_entry.set_text(self.init_prompt)
        self.chat_window.on_send_message(None)


if __name__ == "__main__":
    # Pass the initial prompt from command line arguments
    init_prompt_arg = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else None
    app = ChatApp(init_prompt=init_prompt_arg)
    app.run(None)
