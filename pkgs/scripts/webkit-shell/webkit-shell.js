#!/bin/env gjs

imports.gi.versions.Gtk = "4.0";
imports.gi.versions.Gio = "2.0";
imports.gi.versions.WebKit = "6.0";
const { Gtk, Gio, WebKit, GObject } = imports.gi;
const GLib = imports.gi.GLib;

// Create a custom WebView extension to handle shell commands
var ShellHandler = GObject.registerClass(
  {
    GTypeName: "ShellHandler",
  },
  class ShellHandler extends GObject.Object {
    _init() {
      super._init();
    }

    // Execute shell command and return the output
    executeCommand(command) {
      try {
        let [success, stdout, stderr, exit_status] =
          GLib.spawn_command_line_sync(command);
        return {
          success: success,
          stdout: stdout ? new TextDecoder().decode(stdout) : "",
          stderr: stderr ? new TextDecoder().decode(stderr) : "",
          exitStatus: exit_status,
        };
      } catch (e) {
        return {
          success: false,
          stdout: "",
          stderr: e.toString(),
          exitStatus: -1,
        };
      }
    }
  }
);

let app = new Gtk.Application({ application_id: "net.knoopx.webkit-shell" });

app.connect("activate", () => {
  let args = ARGV;
  let win = new Gtk.ApplicationWindow({
    application: app,
    // decorated: false,
    default_width: 1240,
    default_height: 900,
  });

  let webview = new WebKit.WebView();

  // Enable JavaScript
  let settings = webview.get_settings();
  settings.set_property("enable-javascript", true);
  settings.set_property("enable-write-console-messages-to-stdout", true);

  // Create and initialize the user content manager
  let contentManager = webview.get_user_content_manager();

  // Add the shell handler
  let shellHandler = new ShellHandler();

  // Add the JavaScript interface
  contentManager.connect("script-message-received::shellExec", (_, result) => {
    let command = result.to_string();
    let response = shellHandler.executeCommand(command);

    // Convert response to a JavaScript-friendly string
    let jsResponse = JSON.stringify(response);

    // Inject the response back to the page
    webview.evaluate_javascript(
      `window.dispatchEvent(new CustomEvent('shellResponse', { detail: ${jsResponse} }));`,
      -1,
      null,
      null,
      null,
      () => {}
    );
  });

  // Register the script message handler
  contentManager.register_script_message_handler("shellExec", null);

  // Inject the JavaScript interface into all pages
  let script = `
    window.shellExec = function(command) {
        return new Promise((resolve) => {
            window.addEventListener('shellResponse', function handler(event) {
                window.removeEventListener('shellResponse', handler);
                resolve(event.detail);
            });
            globalThis.webkit.messageHandlers.shellExec.postMessage(command);
        });
    };
    `;

  let injection = WebKit.UserScript.new(
    script,
    WebKit.UserContentInjectedFrames.AllFrames,
    WebKit.UserScriptInjectionTime.Start,
    null,
    null
  );

  contentManager.add_script(injection);

  win.set_child(webview);
  win.show();

  if (args.length > 0) {
    let source = args[0];
    if (!source.includes("://")) {
      let file = Gio.File.new_for_path(source);
      source = file.get_uri();
    }
    webview.load_uri(source);
  } else {
    // Read from stdin
    let content = "";
    let inputStream = new Gio.DataInputStream({
      base_stream: new Gio.UnixInputStream({ fd: 0 }),
    });

    while (true) {
      let [line, length] = inputStream.read_line(null);
      if (length === 0) break;
      content += line + "\n";
    }
    webview.load_html(content, null);
  }
});

app.run(ARGV);
