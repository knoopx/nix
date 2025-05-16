#!/usr/bin/env python3

import gi
import json
import requests
import threading

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")

from gi.repository import Gtk, Adw, Gio, GLib, GObject, Gdk

APP_ID = "net.knoopx.nix-packages"
SEARCH_URL = "https://search.nixos.org/backend/latest-43-nixos-unstable/_search"
AUTH_TOKEN = "Basic YVdWU0FMWHBadjpYOGdQSG56TDUyd0ZFZWt1eHNmUTljU2g="


class PackageItem(GObject.Object):
    __gtype_name__ = "PackageItem"

    name = GObject.Property(type=str)
    version = GObject.Property(type=str)
    description = GObject.Property(type=str)
    homepage = GObject.Property(type=str)
    licenses = GObject.Property(type=str)

    def __init__(self, name, version, description, homepage, licenses):
        super().__init__()
        self.name = name
        self.version = version
        self.description = description if description else "No description available."
        self.homepage = homepage
        self.licenses = licenses


class MainWindow(Adw.ApplicationWindow):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.set_default_size(400, 800)
        self.set_title("Nix Package Search")

        self._package_store = Gio.ListStore.new(PackageItem)
        self._search_delay_id = 0
        self._current_search_thread = None

        # Create a selection model
        self._selection_model = Gtk.SingleSelection(model=self._package_store)

        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(main_box)

        self._header_bar = Adw.HeaderBar()
        main_box.append(self._header_bar)

        self._search_entry = Gtk.SearchEntry(
            hexpand=True, placeholder_text="Search for packages..."
        )
        self._search_entry.connect("search-changed", self._on_search_changed)
        self._search_entry.connect("activate", self._on_search_activated)
        self._header_bar.set_title_widget(self._search_entry)

        self._content_stack = Gtk.Stack()
        self._content_stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE)
        main_box.append(self._content_stack)

        scrolled_window = Gtk.ScrolledWindow(vexpand=True)

        factory = Gtk.SignalListItemFactory()
        factory.connect("setup", self._on_list_item_setup)
        factory.connect("bind", self._on_list_item_bind)

        self._list_view = Gtk.ListView(model=self._selection_model, factory=factory)
        self._list_view.set_vexpand(True)
        self._list_view.set_hexpand(True)
        self._list_view.set_can_focus(True)  # Allow ListView to receive focus

        scrolled_window.set_child(self._list_view)
        self._content_stack.add_named(scrolled_window, "results")

        loading_page = Adw.StatusPage(
            title="Loading...",
            icon_name="find-location-symbolic",
        )
        spinner = Gtk.Spinner(
            spinning=True, halign=Gtk.Align.CENTER, valign=Gtk.Align.CENTER
        )
        loading_page.set_child(spinner)
        self._content_stack.add_named(loading_page, "loading")

        self._empty_page = Adw.StatusPage(
            title="Search for Nix Packages",
            description="Type your query in the search bar above.",
            icon_name="system-search-symbolic",
        )
        self._content_stack.add_named(self._empty_page, "empty")

        self._error_page = Adw.StatusPage(
            title="An Error Occurred",
            description="Could not fetch package information.",
            icon_name="dialog-error-symbolic",
        )
        self._content_stack.add_named(self._error_page, "error")

        self._content_stack.set_visible_child_name("empty")

        # Add event controller for key presses
        key_controller = Gtk.EventControllerKey()
        key_controller.connect("key-pressed", self._on_key_pressed)
        # self.add_controller(key_controller)
        self._search_entry.add_controller(key_controller)

    def _on_search_activated(self, _):
        selected_pos = self._selection_model.get_selected()
        package_item = self._package_store.get_item(selected_pos)
        if package_item:
            if package_item and package_item.homepage:
                Gtk.show_uri(self, package_item.homepage, Gdk.CURRENT_TIME)
            GLib.timeout_add(50, self.get_application().quit)

    def _on_key_pressed(self, controller, keyval, keycode, state):
        selected_pos = self._selection_model.get_selected()

        if keyval == Gdk.KEY_Escape:
            self.get_application().quit()

        if keyval == Gdk.KEY_Up:
            if selected_pos > 0:
                self._selection_model.set_selected(selected_pos - 1)
            return True
        elif keyval == Gdk.KEY_Down:
            if selected_pos < self._package_store.get_n_items() - 1:
                self._selection_model.set_selected(selected_pos + 1)
            return True
        return False

    def _on_list_item_setup(self, factory, list_item):
        box = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL,
            spacing=6,
            margin_top=6,
            margin_bottom=6,
            margin_start=12,
            margin_end=12,
        )
        title_label = Gtk.Label(halign=Gtk.Align.START, xalign=0, wrap=True)
        version_label = Gtk.Label(
            halign=Gtk.Align.START, xalign=0, wrap=True, css_classes=["dim-label"]
        )
        desc_label = Gtk.Label(halign=Gtk.Align.START, xalign=0, wrap=True, lines=3)
        box.append(title_label)
        box.append(version_label)
        box.append(desc_label)
        # Adw.ActionRow's activatable and selectable are False by default which is fine.
        # ListView selection is handled by its own model.
        list_item.set_child(Adw.ActionRow(child=box))

    def _on_list_item_bind(self, factory, list_item):
        package_item = list_item.get_item()
        action_row = list_item.get_child()
        box = action_row.get_child()
        widgets = {}
        child = box.get_first_child()
        idx = 0
        while child:
            if idx == 0:
                widgets["title"] = child
            elif idx == 1:
                widgets["version"] = child
            elif idx == 2:
                widgets["description"] = child
            child = child.get_next_sibling()
            idx += 1
        widgets["title"].set_markup(
            f"<big><b>{GLib.markup_escape_text(package_item.name)}</b></big>"
        )
        widgets["version"].set_text(f"Version: {package_item.version}")
        widgets["description"].set_text(package_item.description)

    def _on_search_changed(self, search_entry):
        if self._search_delay_id > 0:
            GLib.source_remove(self._search_delay_id)
        query = search_entry.get_text().strip()
        if not query:
            self._package_store.remove_all()
            self._empty_page.set_title("Search for Nix Packages")
            self._empty_page.set_description("Type your query in the search bar above.")
            self._content_stack.set_visible_child_name("empty")
            self._search_entry.grab_focus()  # Return focus to search entry
            self._search_delay_id = 0
            return
        self._search_delay_id = GLib.timeout_add(
            300, self._trigger_search_thread, query
        )

    def _trigger_search_thread(self, query):
        self._search_delay_id = 0
        self._content_stack.set_visible_child_name("loading")
        self._package_store.remove_all()  # Clear previous results and selection

        if self._current_search_thread and self._current_search_thread.is_alive():
            print("Note: Previous search thread still running. New search queued.")
            # One might want to implement cancellation for the previous thread here

        self._current_search_thread = threading.Thread(
            target=self._perform_search_request, args=(query,)
        )
        self._current_search_thread.daemon = True
        self._current_search_thread.start()
        return GLib.SOURCE_REMOVE

    def _perform_search_request(self, query):
        query_payload = {
            "query": {
                "bool": {
                    "must": {
                        "multi_match": {
                            "query": query,
                            "fields": [
                                "package_attr_name^3",
                                "package_pname^2",
                                "package_description",
                                "package_programs",
                            ],
                            "operator": "and",
                        }
                    },
                    "filter": [{"term": {"type": "package"}}],
                }
            },
            "size": 50,
            "sort": ["_score"],
            "_source": [
                "package_attr_name",
                "package_pversion",
                "package_description",
                "package_homepage",
                "package_license_set",
            ],
            "track_total_hits": True,
        }

        headers = {
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:138.0) Gecko/20100101 Firefox/138.0",
            "Origin": "https://search.nixos.org/",
            "Accept": "application/json",
            "Authorization": AUTH_TOKEN,
        }

        try:
            response = requests.post(
                SEARCH_URL, json=query_payload, headers=headers, timeout=10
            )
            response.raise_for_status()
            data = response.json()
            GLib.idle_add(self._process_search_results, data, query)
        except requests.exceptions.RequestException as e:
            print(f"Request failed: {e}")
            GLib.idle_add(self._handle_search_error, f"Request failed: {e}")
        except json.JSONDecodeError as e:
            print(f"Failed to parse JSON response: {e}")
            GLib.idle_add(
                self._handle_search_error, f"Invalid response from server: {e}"
            )

    def _handle_search_error(self, error_message):
        if not self.get_visible() or not self.get_application():
            return GLib.SOURCE_REMOVE

        self._error_page.set_description(str(error_message))
        self._content_stack.set_visible_child_name("error")
        return GLib.SOURCE_REMOVE

    def _process_search_results(self, data, original_query):
        if not self.get_visible() or not self.get_application():
            return GLib.SOURCE_REMOVE

        current_query_in_entry = self._search_entry.get_text().strip()
        if original_query != current_query_in_entry:
            print(
                f"Search query changed ('{current_query_in_entry}' vs '{original_query}'), discarding old results."
            )
            return GLib.SOURCE_REMOVE

        try:
            if not isinstance(data, dict) or "hits" not in data:
                raise ValueError("Response JSON missing 'hits' structure")

            hits_outer_obj = data.get("hits")
            if not isinstance(hits_outer_obj, dict) or "hits" not in hits_outer_obj:
                raise ValueError("Response JSON missing 'hits.hits' array")

            packages_array = hits_outer_obj.get("hits")
            if not isinstance(packages_array, list):
                raise ValueError("'hits.hits' is not an array")

            if not packages_array:
                self._empty_page.set_title(
                    f"No Results for '{GLib.markup_escape_text(original_query)}'"
                )
                self._empty_page.set_description(
                    "Try a different search term or check for typos."
                )
                self._content_stack.set_visible_child_name("empty")
                self._search_entry.grab_focus()  # Focus search entry if no results
                return GLib.SOURCE_REMOVE

            for hit_element in packages_array:
                if not isinstance(hit_element, dict) or "_source" not in hit_element:
                    print(f"Warning: Skipping invalid hit element: {hit_element}")
                    continue

                source_obj = hit_element.get("_source")
                if not isinstance(source_obj, dict):
                    print(f"Warning: Skipping hit with invalid _source: {source_obj}")
                    continue

                name = source_obj.get("package_attr_name", "Unknown Package")
                version = source_obj.get("package_pversion", "N/A")
                description = source_obj.get("package_description")

                homepage_list_raw = source_obj.get("package_homepage", [])
                homepage_list = []
                if isinstance(homepage_list_raw, list):
                    for hp in homepage_list_raw:
                        if isinstance(hp, str):
                            homepage_list.append(hp)
                homepage_url = homepage_list[0] if homepage_list else ""

                licenses_list_raw = source_obj.get("package_license_set", [])
                licenses_list = []
                if isinstance(licenses_list_raw, list):
                    for lic in licenses_list_raw:
                        if isinstance(lic, str):
                            licenses_list.append(lic)
                licenses_str = ", ".join(licenses_list)

                package = PackageItem(
                    name, version, description, homepage_url, licenses_str
                )
                self._package_store.append(package)

            if self._package_store.get_n_items() > 0:
                self._content_stack.set_visible_child_name("results")
                self._selection_model.set_selected(0)  # Select the first item
            else:
                # This case implies packages_array was non-empty but all items were invalid
                self._empty_page.set_title(
                    f"No displayable results for '{GLib.markup_escape_text(original_query)}'"
                )
                self._empty_page.set_description(
                    "The server returned data, but it could not be shown."
                )
                self._content_stack.set_visible_child_name("empty")
                self._search_entry.grab_focus()

        except Exception as e:
            print(f"Error processing search results: {e}")
            self._error_page.set_description(f"Could not process search results: {e}")
            self._content_stack.set_visible_child_name("error")

        return GLib.SOURCE_REMOVE


class NixPackageSearchApp(Adw.Application):
    def __init__(self, **kwargs):
        super().__init__(application_id=APP_ID, **kwargs)
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        self.win = MainWindow(application=app)
        self.win.present()


if __name__ == "__main__":
    app = NixPackageSearchApp()
    app.run(None)
