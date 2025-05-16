import gi
gi.require_version('Gtk', '3.0')
# While we require '4.0' for the GObject Introspection API,
# the underlying WebKit2Gtk library might be an older minor version
# that lacks newer API features.
gi.require_version('WebKit2', '4.0')
from gi.repository import Gtk, WebKit2, GLib, Gio
import os
import sys

# Application ID for proper desktop integration and data directory management
APP_ID = "org.example.WebKitShell"
# Name of the subdirectory within the user's data directory for session persistence
SESSION_DATA_DIR_NAME = "webkit-shell"
# Name for the file where cookies will be stored (SQLite is preferred)
COOKIES_FILE_NAME = "cookies.sqlite"

class WebKitShell(Gtk.Application):
    """
    A simple GTK application that wraps a given URL in a WebKit frame.
    No browser elements are displayed, and session data is persisted.
    """
    def __init__(self):
        super().__init__(application_id=APP_ID, flags=Gio.ApplicationFlags.HANDLES_COMMAND_LINE)
        self.url = None
        self.window = None
        self.webview = None
        self.web_context = None # Will be initialized in do_startup

        # Add a command-line option to specify the URL
        self.add_main_option(
            "url",                # Long option name (--url)
            ord('u'),             # Short option name (-u)
            GLib.OptionFlags.NONE,
            GLib.OptionArg.STRING,
            "URL to load in the web view",
            "URL"                 # Argument description in help message
        )

    def do_startup(self):
        """
        Called when the application is starting up.
        Initializes WebKit components and sets up session persistence.
        """
        Gtk.Application.do_startup(self)

        # Determine the user-specific data directory for session persistence
        user_data_dir = GLib.get_user_data_dir()
        session_data_path = os.path.join(user_data_dir, SESSION_DATA_DIR_NAME)
        os.makedirs(session_data_path, exist_ok=True) # Ensure the directory exists

        print(f"Session data will be stored in: {session_data_path}")

        # --- REVISED FIX FOR VERY OLD WEBKIT2GTK VERSIONS ---
        # If WebsiteDataManager constructors are not available,
        # we create the WebContext directly and configure its CookieManager.
        # This is the most compatible way for persistent cookies in older versions.
        # For other persistent data (localStorage, IndexedDB), we rely on WebKit's
        # default behavior for WebContext.new(), which typically means per-user persistence.
        self.web_context = WebKit2.WebContext.new()

        # Attempt to get the CookieManager from the WebContext and configure persistence
        cookie_manager = self.web_context.get_cookie_manager()
        if cookie_manager:
            cookies_file_path = os.path.join(session_data_path, COOKIES_FILE_NAME)
            try:
                # Attempt to use SQLITE for robust cookie storage.
                # This requires WebKit2Gtk 2.16 or newer.
                cookie_manager.set_persistent_storage(cookies_file_path, WebKit2.CookiePersistentStorage.SQLITE)
                print(f"Cookies will be stored in: {cookies_file_path} (SQLITE)")
            except AttributeError:
                # Fallback if SQLITE enum is not available (very old WebKit2Gtk < 2.16)
                try:
                    cookie_manager.set_persistent_storage(cookies_file_path, WebKit2.CookiePersistentStorage.TEXT)
                    print(f"Cookies will be stored in: {cookies_file_path} (TEXT)")
                except Exception as e:
                    print(f"Warning: Could not set persistent storage for cookies (TEXT fallback failed): {e}")
            except Exception as e:
                print(f"Warning: Could not set persistent storage for cookies (SQLITE attempt failed): {e}")
        else:
            print("Warning: Could not get CookieManager from WebContext for explicit persistence.")
        # --- END REVISED FIX ---

        # Create the WebKit WebView with the configured WebContext.
        # This will now be properly initialized as WebContext.new() should always work.
        self.webview = WebKit2.WebView.new_with_context(self.web_context)

    def do_activate(self):
        """
        Called when the application is activated (e.g., launched from desktop or command line).
        Creates the main window and loads the URL.
        """
        if not self.window:
            self.window = Gtk.ApplicationWindow(application=self)
            self.window.set_title("WebKit Shell")
            self.window.set_default_size(800, 600) # Set a reasonable default size

            # Add the WebView directly to the window. No other browser controls are added.
            self.window.add(self.webview) # This should now be a valid object
            self.window.show_all()

            if self.url:
                print(f"Loading URL: {self.url}")
                self.webview.load_uri(self.url)
            else:
                print("No URL provided. Please provide one via '--url <URL>' or as a positional argument.")
                # Display a simple message if no URL is provided
                self.webview.load_html(
                    "<h1>No URL Provided</h1>"
                    "<p>Please launch with a URL, e.g., "
                    "<code>python webkit-shell.py https://www.google.com</code> "
                    "or <code>python webkit-shell.py --url https://www.google.com</code></p>",
                    "file:///" # Base URI for relative paths, not strictly needed for this simple HTML
                )

    def do_command_line(self, command_line):
        """
        Handles command-line arguments.
        Prioritizes the --url flag, then checks for a positional argument.
        """
        options = command_line.get_options_dict()
        options = options.end().unpack() # Unpack GLib.VariantDict to a Python dict

        if 'url' in options:
            self.url = options['url']
        else:
            # Check for positional arguments. args[0] is the program name.
            args = command_line.get_arguments()
            if len(args) > 1:
                self.url = args[1] # The first positional argument is taken as the URL

        self.activate() # Activate the application once arguments are processed
        return 0 # Indicate successful command-line processing

def main():
    """
    Entry point for the application.
    """
    app = WebKitShell()
    exit_status = app.run(sys.argv)
    sys.exit(exit_status)

if __name__ == "__main__":
    main()