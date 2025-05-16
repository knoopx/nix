#!/usr/bin/env python3

import gi
import datetime
import threading
import dateparser

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
gi.require_version('EDataServer', '1.2')
gi.require_version('ECal', '2.0')
gi.require_version('ICal', '3.0')

from gi.repository import Gtk, Adw, Gdk, GLib, EDataServer, ECal, ICal, GObject
from dateutil import tz

class CalendarEventApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="com.example.calendar_event_creator")
        self.connect('activate', self.on_activate)
        self.local_tz = tz.tzlocal()

    def on_activate(self, app):
        # Create main window
        self.win = Adw.ApplicationWindow(application=app)
        self.win.set_default_size(800, 500)
        self.win.set_title("Calendar Event Creator")

        # Create main box
        main_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
        main_box.set_margin_top(24)
        main_box.set_margin_bottom(24)
        main_box.set_margin_start(24)
        main_box.set_margin_end(24)

        # Create calendar (non-interactive)
        self.calendar = Gtk.Calendar()
        self.calendar.set_hexpand(True)
        self.calendar.set_vexpand(True)
        self.calendar.set_sensitive(False)  # Make calendar non-interactive

        # Create form
        form_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        form_box.set_hexpand(True)

        # Title entry
        title_box = Adw.PreferencesGroup(title="Event Details")

        title_row = Adw.EntryRow(title="Title")
        self.title_entry = title_row
        self.title_entry.connect("activate", self.on_entry_activate)
        title_box.add(title_row)

        # Time entry
        time_row = Adw.EntryRow(title="Time")
        self.time_entry = time_row
        self.time_entry.connect("changed", self.on_time_changed)
        self.time_entry.connect("activate", self.on_entry_activate)
        title_box.add(time_row)

        # Time preview
        self.time_preview = Adw.ActionRow(title="Time Preview", subtitle="Enter a time above")
        title_box.add(self.time_preview)

        # Create button
        button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        button_box.set_halign(Gtk.Align.END)
        button_box.set_margin_top(24)

        create_button = Gtk.Button(label="Create Event")
        create_button.add_css_class("suggested-action")
        create_button.connect("clicked", self.on_create_event)
        button_box.append(create_button)

        # Assemble form box
        form_box.append(title_box)
        form_box.append(button_box)

        # Assemble main layout
        left_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        left_box.set_hexpand(True)
        left_box.append(self.calendar)

        main_box.append(left_box)
        main_box.append(form_box)

        self.win.set_content(main_box)
        self.win.present()

        # Focus title entry by default
        self.title_entry.grab_focus()

        # Initialize calendar client
        self.init_calendar_client()

    def init_calendar_client(self):
        threading.Thread(target=self._init_calendar_client_thread, daemon=True).start()

    def _init_calendar_client_thread(self):
        try:
            # Get registry
            registry = EDataServer.SourceRegistry.new_sync(None)

            # Find default calendar
            default_source = registry.ref_default_calendar()

            # Create client
            self.client = ECal.Client.connect_sync(
                default_source,
                ECal.ClientSourceType.EVENTS,
                30,  # timeout in seconds
                None
            )

            GLib.idle_add(lambda: self._show_toast("Connected to calendar service"))
        except Exception as e:
            GLib.idle_add(lambda: self._show_toast(f"Failed to connect to calendar: {str(e)}"))

    def _show_toast(self, message):
        toast = Adw.Toast.new(message)
        toast.set_timeout(3)
        toast_overlay = Adw.ToastOverlay()
        toast_overlay.add_toast(toast)
        return False

    def on_entry_activate(self, entry):
        # Submit form when Enter is pressed
        self.on_create_event(None)

    def on_time_changed(self, entry):
        text = entry.get_text()
        if not text:
            self.time_preview.set_subtitle("Enter a time above")
            return

        try:
            parsed_time = dateparser.parse(text)
            if parsed_time:
                local_time = parsed_time.astimezone(self.local_tz)
                formatted_time = local_time.strftime("%A, %B %d, %Y at %I:%M %p")
                self.time_preview.set_subtitle(formatted_time)

                # Update calendar to show selected date
                self.calendar.select_day(GLib.DateTime.new_local(
                    local_time.year,
                    local_time.month,
                    local_time.day,
                    0, 0, 0
                ))
            else:
                self.time_preview.set_subtitle("Unable to parse time")
        except Exception as e:
            self.time_preview.set_subtitle(f"Error: {str(e)}")

    def on_create_event(self, button):
        title = self.title_entry.get_text()
        time_text = self.time_entry.get_text()

        if not title:
            self._show_toast("Please enter a title")
            return

        if not time_text:
            self._show_toast("Please enter a time")
            return

        parsed_time = dateparser.parse(time_text)
        if not parsed_time:
            self._show_toast("Unable to parse time")
            return

        threading.Thread(target=self._create_event_thread, args=(title, parsed_time), daemon=True).start()

    def _create_event_thread(self, title, start_time):
        # try:
            # Default duration: 1 hour
            end_time = start_time + datetime.timedelta(hours=1)

            # Create component (event)
            icalcomp = ECal.Component.new()
            icalcomp.set_new_vtype(ECal.ComponentVType.EVENT)

            # Set summary (title)
            icalcomp.set_summary(ECal.ComponentText.new(title, None))

            # Convert datetime to Unix timestamp
            start_timestamp = int(start_time.timestamp())
            end_timestamp = int(end_time.timestamp())

            # Create ICal time objects
            start_icaltimetype = ICal.Time.new_from_timet_with_zone(start_timestamp, 0, None)
            end_icaltimetype = ICal.Time.new_from_timet_with_zone(end_timestamp, 0, None)

            icalcomp.set_dtstart(start_icaltimetype)
            icalcomp.set_dtend(end_icaltimetype)

            # Add event to calendar
            self.client.create_object_sync(icalcomp, ECal.OperationFlags.NONE, None)

            GLib.idle_add(lambda: self._show_success_toast(title, start_time))
        # except Exception as e:
        #     GLib.idle_add(lambda: self._show_toast(f"Failed to create event: {str(e)}"))

    def _show_success_toast(self, title, time):
        local_time = time.astimezone(self.local_tz)
        formatted_time = local_time.strftime("%B %d at %I:%M %p")
        self._show_toast(f"Created event: {title} on {formatted_time}")

        # Clear form
        self.title_entry.set_text("")
        self.time_entry.set_text("")

        # Focus title entry again
        self.title_entry.grab_focus()

        return False

if __name__ == "__main__":
    app = CalendarEventApp()
    app.run(None)