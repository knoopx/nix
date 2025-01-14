#!/bin/env/gjs

imports.gi.versions.Gtk = "4.0";
imports.gi.versions.GLib = "2.0";
imports.gi.versions.Gio = "2.0";
imports.gi.versions.Gdk = "4.0";

const { GObject, Gtk, GLib, Gio, Gdk } = imports.gi;

const css = `
* {
    font-family: monospace;
}
`;

class FuzzyFinder {
  constructor() {
    this.items = [];
    this.filteredItems = [];
  }

  fuzzyMatch(pattern, str) {
    pattern = pattern.toLowerCase();
    str = str.toLowerCase();

    let patternIdx = 0;
    let strIdx = 0;

    while (patternIdx < pattern.length && strIdx < str.length) {
      if (pattern[patternIdx] === str[strIdx]) {
        patternIdx++;
      }
      strIdx++;
    }

    return patternIdx === pattern.length;
  }

  filter(query) {
    if (!query) {
      this.filteredItems = [...this.items];
      return;
    }

    this.filteredItems = this.items.filter((item) =>
      this.fuzzyMatch(query, item)
    );
  }
}

const FuzzyFinderWindow = GObject.registerClass(
  {
    GTypeName: "FuzzyFinderWindow",
  },
  class FuzzyFinderWindow extends Gtk.ApplicationWindow {
    constructor(application) {
      super({
        application,
      });

      this.fuzzyFinder = new FuzzyFinder();
      this.setupUI();
      this.setupKeyboardShortcuts();
      this.loadItems();
    }

    setupUI() {
      this.set_default_size(1240, 900);

      const vbox = new Gtk.Box({
        orientation: Gtk.Orientation.VERTICAL,
      });
      this.set_child(vbox);

      this.searchEntry = new Gtk.SearchEntry({
        placeholder_text: "Type to filter...",
        hexpand: true,
      });

      const headerBar = new Gtk.HeaderBar();
      headerBar.set_title_widget(this.searchEntry);

      this.set_titlebar(headerBar);

      const scrolled = new Gtk.ScrolledWindow({
        vexpand: true,
        hscrollbar_policy: Gtk.PolicyType.NEVER,
      });
      vbox.append(scrolled);

      this.listBox = new Gtk.ListBox({
        selection_mode: Gtk.SelectionMode.SINGLE,
      });
      scrolled.set_child(this.listBox);

      this.searchEntry.connect(
        "search-changed",
        this._onSearchChanged.bind(this)
      );
      this.listBox.connect("row-activated", this._onRowActivated.bind(this));


      this._currentSelection = 0;

      const searchKeyController = new Gtk.EventControllerKey();
      searchKeyController.connect(
        "key-pressed",
        (controller, keyval, keycode, state) => {
          if (keyval === Gdk.KEY_Escape) {
            this.application.quit();
            return true;
          }
          return false;
        }
      );
      this.searchEntry.add_controller(searchKeyController);
    }

    setupKeyboardShortcuts() {
      const keyController = new Gtk.EventControllerKey();

      keyController.connect(
        "key-pressed",
        (controller, keyval, keycode, state) => {
          const key = keyval;
          const modifiers = state;

          switch (key) {
            case Gdk.KEY_Escape:
              this.application.quit();
              return true;

            case Gdk.KEY_Return:
              const selected = this.listBox.get_selected_row();
              if (selected) {
                this._onRowActivated(this.listBox, selected);
              }
              return true;

            case Gdk.KEY_Up:
            case Gdk.KEY_Control_L | Gdk.KEY_p:
              this._moveSelection(-1);
              return true;

            case Gdk.KEY_Down:
            case Gdk.KEY_Control_L | Gdk.KEY_n:
              this._moveSelection(1);
              return true;

            case Gdk.KEY_Page_Up:
              this._moveSelection(-10);
              return true;

            case Gdk.KEY_Page_Down:
              this._moveSelection(10);
              return true;

            case Gdk.KEY_Home:
              this._moveToEnd(true);
              return true;

            case Gdk.KEY_End:
              this._moveToEnd(false);
              return true;

            case Gdk.KEY_Tab:
              return false;
          }

          if (!this.searchEntry.has_focus) {
            const char = String.fromCharCode(keyval);
            if (/^[a-zA-Z0-9]$/.test(char)) {
              this.searchEntry.grab_focus();
              return false;
            }
          }

          return false;
        }
      );

      this.add_controller(keyController);
    }

    _countRows() {
      let count = 0;
      let child = this.listBox.get_first_child();
      while (child) {
        count++;
        child = child.get_next_sibling();
      }
      return count;
    }

    _getRowAtIndex(index) {
      let current = this.listBox.get_first_child();
      let currentIndex = 0;

      while (current && currentIndex < index) {
        current = current.get_next_sibling();
        currentIndex++;
      }

      return current;
    }

    _moveSelection(delta) {
      const rowCount = this._countRows();
      if (rowCount === 0) return;

      let currentIndex = this._currentSelection;
      let newIndex = currentIndex + delta;

      newIndex = Math.max(0, Math.min(newIndex, rowCount - 1));

      if (newIndex !== currentIndex) {
        this._currentSelection = newIndex;
        const row = this._getRowAtIndex(newIndex);
        if (row) {
          this.listBox.select_row(row);
          row.grab_focus();
        }
      }
    }

    _moveToEnd(toStart) {
      const rowCount = this._countRows();
      if (rowCount === 0) return;

      const index = toStart ? 0 : rowCount - 1;
      this._currentSelection = index;
      const row = this._getRowAtIndex(index);
      if (row) {
        this.listBox.select_row(row);
        row.grab_focus();
      }
    }

    loadItems() {
      const stream = new Gio.DataInputStream({
        base_stream: new Gio.UnixInputStream({ fd: 0 }),
      });

      try {
        let line;
        while ((line = stream.read_line(null)[0]) !== null) {
          const text = new TextDecoder().decode(line);
          this.fuzzyFinder.items.push(text);
        }
      } catch (e) {
        log(`Error reading from stdin: ${e.message}`);
      }

      this.fuzzyFinder.filteredItems = [...this.fuzzyFinder.items];
      this._updateList();
    }

    _updateList() {
      let child = this.listBox.get_first_child();
      while (child) {
        const next = child.get_next_sibling();
        this.listBox.remove(child);
        child = next;
      }

      for (const item of this.fuzzyFinder.filteredItems) {
        const label = new Gtk.Label({
          label: item,
          xalign: 0,
          margin_start: 6,
          margin_end: 6,
          margin_top: 3,
          margin_bottom: 3,
        });
        const row = new Gtk.ListBoxRow();
        row.set_child(label);
        this.listBox.append(row);
      }

      if (this.fuzzyFinder.filteredItems.length > 0) {
        this._currentSelection = 0;
        const firstRow = this._getRowAtIndex(0);
        if (firstRow) {
          this.listBox.select_row(firstRow);
        }
      }
    }

    _onSearchChanged() {
      const text = this.searchEntry.get_text();
      this.fuzzyFinder.filter(text);
      this._updateList();
    }

    _onRowActivated(listBox, row) {
      const label = row.get_child();
      print(label.get_text());
      this.application.quit();
    }
  }
);

const FuzzyFinderApp = GObject.registerClass(
  {
    GTypeName: "FuzzyFinderApp",
  },
  class FuzzyFinderApp extends Gtk.Application {
    vfunc_activate() {
      let window = new FuzzyFinderWindow(this);
      window.present();
      window.searchEntry.grab_focus();
    }
  }
);

Gtk.init();

const cssProvider = new Gtk.CssProvider();
cssProvider.load_from_data(css, css.length);

Gtk.StyleContext.add_provider_for_display(
  Gdk.Display.get_default(),
  cssProvider,
  Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
);

const app = new FuzzyFinderApp();
app.run([imports.system.programInvocationName].concat(ARGV));
