#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 -p libadwaita -p python3Packages.pygobject3 -p python3Packages.openai
#
# -p python312Packages.markdown2 -p gtksourceview5  -p webkitgtk_6_0

import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")  # Optional, for Adw.Application
from gi.repository import Gtk, GLib, Gio, Adw

import openai
import os
import threading

# --- OpenAI Client Setup ---
# Ensure your OPENAI_API_KEY environment variable is set
try:
    client = openai.OpenAI(
        api_key=os.getenv("OPENAI_API_KEY"), base_url=os.getenv("OPENAI_API_BASE")
    )
except openai.OpenAIError as e:
    print(f"Error initializing OpenAI client: {e}")
    print("Please ensure your OPENAI_API_KEY environment variable is set correctly.")
    client = None


class OpenAIStreamer:
    def __init__(self, model="gpt-3.5-turbo"):
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
            # try:
                stream = client.chat.completions.create(
                    model=self.model, messages=messages_to_send, stream=True
                )
                assistant_response = ""
                for chunk in stream:
                    if chunk.choices:
                        content = chunk.choices[0].delta.content
                        if content:
                            assistant_response += content
                            GLib.idle_add(
                                on_chunk_received, content
                            )  # Schedule UI update on main thread
                GLib.idle_add(
                    on_stream_end, assistant_response
                )  # Pass full response for history
            # except openai.APIError as e:
            #     error_message = f"OpenAI API Error: {e}"
            #     print(error_message)
            #     GLib.idle_add(on_error, error_message)
            # except Exception as e:
            #     error_message = f"An unexpected error occurred: {e}"
            #     print(error_message)
            #     GLib.idle_add(on_error, error_message)

        thread = threading.Thread(target=stream_worker)
        thread.daemon = True  # Allow main program to exit even if thread is running
        thread.start()


class ChatAppWindow(Gtk.ApplicationWindow):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.streamer = OpenAIStreamer()

        self.set_default_size(600, 700)
        self.set_title("OpenAI Chat GTK4")

        self.main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.set_child(self.main_box)

        # Chat history TextView
        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_hexpand(True)
        scrolled_window.set_vexpand(True)

        self.chat_view = Gtk.TextView()
        self.chat_view.set_editable(False)
        self.chat_view.set_cursor_visible(False)
        self.chat_view.set_wrap_mode(Gtk.WrapMode.WORD_CHAR)
        self.chat_buffer = self.chat_view.get_buffer()
        scrolled_window.set_child(self.chat_view)
        self.main_box.append(scrolled_window)

        # Create Pango tags for basic styling
        self.user_tag = self.chat_buffer.create_tag(
            "user_message", foreground="blue", weight=700
        )  # Bold
        self.assistant_tag = self.chat_buffer.create_tag(
            "assistant_message", foreground="green"
        )
        self.error_tag = self.chat_buffer.create_tag(
            "error_message", foreground="red", style=Pango.Style.ITALIC
        )
        self.info_tag = self.chat_buffer.create_tag(
            "info_message", foreground="gray", style=Pango.Style.ITALIC
        )

        # Input area
        input_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        self.input_entry = Gtk.Entry()
        self.input_entry.set_hexpand(True)
        self.input_entry.connect("activate", self.on_send_message)  # Send on Enter key
        input_box.append(self.input_entry)

        send_button = Gtk.Button(label="Send")
        send_button.connect("clicked", self.on_send_message)
        input_box.append(send_button)

        self.main_box.append(input_box)
        self.main_box.set_margin_top(6)
        self.main_box.set_margin_bottom(6)
        self.main_box.set_margin_start(6)
        self.main_box.set_margin_end(6)

    def _append_message_with_tag(self, text, tag_name=None):
        """Appends text to the chat_buffer and applies a tag."""
        end_iter = self.chat_buffer.get_end_iter()
        start_mark = self.chat_buffer.create_mark(None, end_iter, True)
        self.chat_buffer.insert(end_iter, text + "\n\n")
        end_mark = self.chat_buffer.create_mark(
            None, self.chat_buffer.get_end_iter(), True
        )

        if tag_name:
            tag = self.chat_buffer.get_tag_table().lookup(tag_name)
            if tag:
                start_iter_for_tag = self.chat_buffer.get_iter_at_mark(start_mark)
                end_iter_for_tag = self.chat_buffer.get_iter_at_mark(end_mark)
                # Adjust end_iter_for_tag to not include the trailing newlines in the tag
                end_iter_for_tag.backward_chars(2)
                self.chat_buffer.apply_tag(tag, start_iter_for_tag, end_iter_for_tag)

        self.chat_buffer.delete_mark(start_mark)
        self.chat_buffer.delete_mark(end_mark)

        # Auto-scroll to the end
        adj = self.chat_view.get_parent().get_vadjustment()
        if adj:
            GLib.idle_add(adj.set_value, adj.get_upper() - adj.get_page_size())

    def append_user_message(self, text):
        self._append_message_with_tag(f"You: {text}", "user_message")
        self.current_assistant_message_start_mark = self.chat_buffer.create_mark(
            "assistant_start", self.chat_buffer.get_end_iter(), True
        )
        # Add a placeholder for the assistant's response
        self._append_message_with_tag("Assistant: ", "assistant_message")

    def append_stream_chunk(self, chunk):
        if (
            not self.current_assistant_message_start_mark
        ):  # Should not happen if append_user_message was called
            return

        # Insert chunk at the end of the "Assistant: " part
        insert_iter = self.chat_buffer.get_iter_at_mark(
            self.current_assistant_message_start_mark
        )
        # Move to the end of the current assistant message (before the \n\n)
        while not insert_iter.ends_line():
            insert_iter.forward_char()

        self.chat_buffer.insert_with_tags_by_name(
            insert_iter, chunk, "assistant_message"
        )

        # Auto-scroll
        adj = self.chat_view.get_parent().get_vadjustment()
        if adj:
            GLib.idle_add(adj.set_value, adj.get_upper() - adj.get_page_size())

    def handle_stream_end(self, full_assistant_response):
        self.streamer.add_message("assistant", full_assistant_response)
        if self.current_assistant_message_start_mark:
            self.chat_buffer.delete_mark(self.current_assistant_message_start_mark)
            self.current_assistant_message_start_mark = None
        self.input_entry.set_sensitive(True)  # Re-enable input

    def handle_stream_error(self, error_message):
        self._append_message_with_tag(f"Error: {error_message}", "error_message")
        if self.current_assistant_message_start_mark:
            self.chat_buffer.delete_mark(self.current_assistant_message_start_mark)
            self.current_assistant_message_start_mark = None
        self.input_entry.set_sensitive(True)  # Re-enable input

    def on_send_message(self, widget):
        if not client:
            self.handle_stream_error(
                "OpenAI client is not initialized. Cannot send message."
            )
            return

        prompt = self.input_entry.get_text()
        if not prompt.strip():
            return

        self.append_user_message(prompt)
        self.input_entry.set_text("")
        self.input_entry.set_sensitive(False)  # Disable input while streaming

        self.streamer.get_completion_stream(
            prompt,
            on_chunk_received=self.append_stream_chunk,
            on_stream_end=self.handle_stream_end,
            on_error=self.handle_stream_error,
        )


class ChatApp(
    Adw.Application
):  # Using Adw.Application for a more modern feel, Gtk.Application is also fine
    def __init__(self, **kwargs):
        super().__init__(application_id="org.example.openaichatgtk4", **kwargs)
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        self.win = ChatAppWindow(application=app)
        self.win.present()


if __name__ == "__main__":
    # Import Pango for text styling (if not already at the top)
    try:
        from gi.repository import Pango
    except ImportError:
        print("Pango not found, text styling will be basic.")
        Pango = None

    app = ChatApp()
    app.run(None)
