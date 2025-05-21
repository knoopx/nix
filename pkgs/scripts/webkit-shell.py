#!/usr/bin/env python

import gi

gi.require_version("Gtk", "4.0")
gi.require_version("WebKit", "6.0")
from gi.repository import Gtk, Gdk, WebKit, GLib, Gio
import os
import sys
import argparse

# Application ID for proper desktop integration and data directory management
APP_ID = "net.knoopx.webkit-shell"
# Name for the file where cookies will be stored (SQLite is preferred)
COOKIES_FILE_NAME = "cookies.sqlite"


class WebKitShell(Gtk.Application):
    """
    A simple GTK application that wraps a given URL in a WebKit frame.
    No browser elements are displayed, and session data is persisted.
    """

    def __init__(
        self, app_id=APP_ID, url=None, width=800, height=600, title="WebKit Shell"
    ):
        super().__init__(
            application_id=app_id,
            flags=Gio.ApplicationFlags.HANDLES_COMMAND_LINE
            | Gio.ApplicationFlags.REPLACE,
        )
        self.url = url
        self.window_width = width
        self.window_height = height
        self.window = None  # Initialize window attribute
        self.webview = None
        self.web_context = None  # Will be initialized in do_startup
        self.app_id = app_id  # Store the application ID
        self.title = title

    def do_startup(self):
        Gtk.Application.do_startup(self)

        # Determine the user-specific data directory for session persistence
        user_data_dir = GLib.get_user_data_dir()
        session_data_path = os.path.join(user_data_dir, self.app_id)
        os.makedirs(session_data_path, exist_ok=True)

        print(f"Session data will be stored in: {session_data_path}")

    def on_decide_policy(self, webview, decision, decision_type):
        if decision_type == WebKit.PolicyDecisionType.NAVIGATION_ACTION:
            navigation_action = decision.get_navigation_action()
            if (
                navigation_action.get_navigation_type()
                == WebKit.NavigationType.LINK_CLICKED
            ):
                uri = navigation_action.get_request().get_uri()
                if uri.startswith("http://") or uri.startswith("https://"):
                    decision.ignore()
                    Gtk.show_uri(None, uri, Gdk.CURRENT_TIME)  # Requires Gtk 4.4+
                    return True  # Indicate that we handled the decision
        return False  # Allow other types of decisions/navigations

    def do_activate(self):
        """
        Called when the application is activated (e.g., launched from desktop or command line).
        Creates the main window and loads the URL.
        """
        if not self.webview:
            # Configure settings for WebKit 6.0
            settings = WebKit.Settings.new()
            settings.set_enable_developer_extras(True)
            settings.set_enable_javascript(True)
            settings.set_enable_write_console_messages_to_stdout(True)
            settings.set_property("allow-file-access-from-file-urls", True)
            settings.set_property("allow-universal-access-from-file-urls", True)
            settings.set_property("enable-developer-extras", True)
            settings.set_property("enable-javascript", True)
            settings.set_property("enable-media-stream", True)
            settings.set_property("enable-site-specific-quirks", True)
            settings.set_property("enable-webgl", True)
            settings.set_property("enable-write-console-messages-to-stdout", True)

            # Create WebView with settings
            self.webview = WebKit.WebView()
            self.webview.set_settings(settings)
            self.webview.connect("decide-policy", self.on_decide_policy)

        if not self.window:
            self.window = Gtk.ApplicationWindow(application=self)
            self.window.set_title(self.title)

            # Set default size or use values from command-line arguments
            width = 800  # Default width
            height = 600  # Default height
            if hasattr(self, "window_width") and hasattr(self, "window_height"):
                width = self.window_width
                height = self.window_height

            self.window.set_default_size(width, height)

            # Create a box to hold the WebView (required in GTK 4)
            self.window.set_child(self.webview)  # GTK 4 uses set_child instead of add

            self.window.present()  # GTK 4 uses present instead of show_all

            if self.url:
                print(f"Loading URL: {self.url}")
                self.webview.load_uri(self.url)
            else:
                print(
                    "No URL provided. Please provide one via '--url <URL>' or as a positional argument."
                )
                self.webview.load_html(
                    "<h1>No URL Provided</h1>"
                    "<p>Please launch with a URL, e.g., "
                    "<code>python webkit-shell.py https://www.google.com</code> "
                    "or <code>python webkit-shell.py --url https://www.google.com</code></p>",
                    "file:///",
                )

    def do_command_line(self, command_line):
        """
        Handles command-line arguments.
        If this is called on an existing instance, it will update the window.
        """
        options = command_line.get_options_dict()
        options = options.end().unpack()

        # Update window settings if this is a second instance
        if self.window:
            if "width" in options or "height" in options:
                width = options.get("width", self.window_width)
                height = options.get("height", self.window_height)
                self.window.set_default_size(width, height)

            if "url" in options:
                self.url = options["url"]
                self.webview.load_uri(self.url)

            if "title" in options:
                self.window.set_title(options["title"])

            self.window.present()
        else:
            self.activate()

        return 0


def main():
    """
    Entry point for the application.
    Parse arguments and initialize the application.
    """
    parser = argparse.ArgumentParser(description="WebKit Shell - A minimal web browser")
    parser.add_argument(
        "--app-id", "-a", default=APP_ID, help="Application ID for the GTK application"
    )
    parser.add_argument("--url", "-u", help="URL to load in the web view")
    parser.add_argument("--width", "-w", type=int, default=800, help="Window width")
    parser.add_argument("--height", "-t", type=int, default=600, help="Window height")
    parser.add_argument("--title", "-l", default="WebKit Shell", help="Window title")

    args = parser.parse_args()

    app = WebKitShell(
        app_id=args.app_id,
        url=args.url,
        width=args.width,
        height=args.height,
        title=args.title,
    )
    exit_status = app.run(sys.argv)
    sys.exit(exit_status)


if __name__ == "__main__":
    main()
