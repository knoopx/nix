#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 -p python3Packages.pygobject3 -p webkitgtk -p python312Packages.markdown2

import gi

gi.require_version("WebKit2", "4.0")
from gi.repository import WebKit2, Gtk
from markdown2 import markdown


def render_markdown(markdown_content):
    html_content = markdown(markdown_content)
    return f"<html><body>{html_content}</body></html>"


class MarkdownViewer(Gtk.Window):
    def __init__(self, markdown_content):
        super().__init__(title="Markdown Viewer")
        self.set_default_size(800, 600)

        webview = WebKit2.WebView()
        html_content = render_markdown(markdown_content)
        print(html_content)
        webview.load_html(html_content)

        self.add(webview)


if __name__ == "__main__":
    content = """
# Hello, GTK3
This is **Markdown** rendered using *WebKitGTK*.
    """

    win = MarkdownViewer(content)
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()
