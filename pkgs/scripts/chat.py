#!/usr/bin/env python

import sys
import gi
import openai
import os
import threading

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Gtk, GLib, Pango, Adw


client = openai.OpenAI(
    api_key=os.getenv("OPENAI_API_KEY"), base_url=os.getenv("OPENAI_API_BASE")
)


class MessageBubble(Gtk.Box):
    def __init__(self, message, className="user-bubble"):
        super().__init__(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        self.set_halign(Gtk.Align.START)
        self.set_margin_start(12)
        self.set_margin_end(12)
        self.set_margin_top(6)
        self.set_margin_bottom(6)

        # Constrain width to prevent window expansion
        self.set_size_request(-1, -1)  # Natural height, constrained width

        # Label to hold the text
        label = Gtk.Label(label=message)
        label.set_selectable(True)
        label.set_wrap(True)  # Enable text wrapping
        label.set_wrap_mode(
            Pango.WrapMode.WORD_CHAR
        )  # Wrap at word boundaries or characters

        # label.set_max_width_chars(60)  # Limit width in characters
        label.set_xalign(0.0)  # Left align text within the label
        label.set_ellipsize(Pango.EllipsizeMode.NONE)  # Don't ellipsize, wrap instead

        # Bubble container
        bubble = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        bubble.add_css_class(className)
        bubble.set_margin_start(10)
        bubble.set_margin_end(10)
        bubble.set_margin_top(5)
        bubble.set_margin_bottom(5)
        bubble.append(label)

        self.append(bubble)


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
        self.messages_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.messages_box.set_margin_start(10)
        self.messages_box.set_margin_end(10)
        self.messages_box.set_margin_top(10)
        self.messages_box.set_margin_bottom(10)

        # Use a viewport to allow the messages box to expand
        viewport = Gtk.Viewport()
        viewport.set_child(self.messages_box)
        self.scrolled_window.set_child(viewport)

        self.main_box.append(self.scrolled_window)

        # Input area at the bottom
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
        send_button.add_css_class("suggested-action")  # Blue accent button
        input_box.append(send_button)

        self.main_box.append(input_box)

        self.input_entry.grab_focus()

    def setup_css(self):
        css_provider = Gtk.CssProvider()
        css = """
        .user-bubble, .assistant-bubble, .error-bubble {
            color: #cdd6f4;
            border-radius: 18px;
            padding: 10px 14px;
        }
        .user-bubble { background-color: #181825; }
        .assistant-bubble { background-color: #313244; }
        .error-bubble {
            background-color: #f5e0dc;
            color: #f38ba8;
        }
        """
        css_provider.load_from_data(css.encode())
        Gtk.StyleContext.add_provider_for_display(
            self.get_display(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

    def add_message_bubble(self, text, className):
        bubble = MessageBubble(text, className)
        self.messages_box.append(bubble)
        # Scroll to the bottom to show the new message
        GLib.idle_add(self.scroll_to_bottom)

    def scroll_to_bottom(self):
        adj = self.scrolled_window.get_vadjustment()
        if adj:
            adj.set_value(adj.get_upper() - adj.get_page_size())
        return False  # Remove idle callback

    def on_send_message(self, widget):
        if not client:
            self.add_message_bubble(
                "OpenAI client is not initialized. Cannot send message.", "error-bubble"
            )
            return

        prompt = self.input_entry.get_text()
        if not prompt.strip():
            return

        # Add user message bubble
        self.add_message_bubble(prompt, "user-bubble")
        self.input_entry.set_text("")
        self.input_entry.set_sensitive(False)  # Disable input while streaming

        # Reset the current assistant message
        self.current_assistant_message = ""

        # Start streaming the response
        self.streamer.get_completion_stream(
            prompt,
            on_chunk_received=self.handle_stream_chunk,
            on_stream_end=self.handle_stream_end,
            on_error=self.handle_stream_error,
        )

    def handle_stream_chunk(self, chunk):
        if not self.current_assistant_message:
            # First chunk - create the initial bubble
            self.current_assistant_message = chunk
            self.add_message_bubble(chunk, "assistant-bubble")
        else:
            # Update existing bubble
            self.current_assistant_message += chunk

            # Remove the last bubble and replace with updated content
            last_child = self.messages_box.get_last_child()
            if last_child:
                self.messages_box.remove(last_child)

            self.add_message_bubble(self.current_assistant_message, "assistant-bubble")

    def handle_stream_end(self, full_assistant_response):
        self.streamer.add_message("assistant", full_assistant_response)
        self.input_entry.set_sensitive(True)  # Re-enable input
        self.input_entry.grab_focus()

    def handle_stream_error(self, error_message):
        self.add_message_bubble(error_message, "error-bubble")
        self.input_entry.set_sensitive(True)  # Re-enable input
        self.input_entry.grab_focus()


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
        app.chat_window.input_entry.set_text(self.init_prompt)
        app.chat_window.on_send_message(None)


if __name__ == "__main__":
    app = ChatApp(init_prompt=" ".join(sys.argv[1:]) if len(sys.argv) > 1 else None)
    app.run(None)
