{
  lib,
  nixosConfig,
  ...
}: let
  c = nixosConfig.defaults.colorScheme.palette;

  toHex = hex: "#${hex}ff";

  theme = {
    "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
    name = "Base16 custom";
    author = "Tinted Theming (https://github.com/tinted-theming)";
    themes = [
      {
        name = "Base16 custom";
        appearance = "dark";
        style = {
          border = toHex c.base02;
          "border.variant" = toHex c.base01;
          "border.focused" = toHex c.base07;
          "border.selected" = toHex c.base02;
          "border.transparent" = "00000000";
          "border.disabled" = toHex c.base03;
          "elevated_surface.background" = toHex c.base01;
          "surface.background" = toHex c.base01;
          background = toHex c.base00;
          "element.background" = toHex c.base01;
          "element.hover" = toHex c.base02;
          "element.active" = toHex c.base02;
          "element.selected" = toHex c.base02;
          "element.disabled" = toHex c.base01;
          "drop_target.background" = "${c.base03}80";
          "ghost_element.background" = "00000000";
          "ghost_element.hover" = toHex c.base02;
          "ghost_element.active" = toHex c.base02;
          "ghost_element.selected" = toHex c.base02;
          "ghost_element.disabled" = toHex c.base01;
          text = toHex c.base05;
          "text.muted" = toHex c.base04;
          "text.placeholder" = toHex c.base03;
          "text.disabled" = toHex c.base03;
          "text.accent" = toHex c.base07;
          icon = toHex c.base05;
          "icon.muted" = toHex c.base04;
          "icon.disabled" = toHex c.base03;
          "icon.placeholder" = toHex c.base04;
          "icon.accent" = toHex c.base07;
          "status_bar.background" = toHex c.base01;
          "title_bar.background" = toHex c.base01;
          "title_bar.inactive_background" = toHex c.base00;
          "toolbar.background" = toHex c.base00;
          "tab_bar.background" = toHex c.base01;
          "tab.inactive_background" = toHex c.base01;
          "tab.active_background" = toHex c.base00;
          "search.match_background" = "${c.base07}66";
          "search.active_match_background" = "${c.base09}66";
          "panel.background" = toHex c.base01;
          "panel.focused_border" = null;
          "pane.focused_border" = null;
          "scrollbar.thumb.background" = "${c.base04}4c";
          "scrollbar.thumb.hover_background" = toHex c.base02;
          "scrollbar.thumb.border" = toHex c.base02;
          "scrollbar.track.background" = "00000000";
          "scrollbar.track.border" = toHex c.base01;
          "editor.foreground" = toHex c.base05;
          "editor.background" = toHex c.base00;
          "editor.gutter.background" = toHex c.base00;
          "editor.subheader.background" = toHex c.base01;
          "editor.active_line.background" = "${c.base01}80";
          "editor.highlighted_line.background" = toHex c.base01;
          "editor.line_number" = toHex c.base03;
          "editor.active_line_number" = toHex c.base05;
          "editor.hover_line_number" = toHex c.base04;
          "editor.invisible" = toHex c.base03;
          "editor.wrap_guide" = "${c.base02}0d";
          "editor.active_wrap_guide" = "${c.base02}1a";
          "editor.document_highlight.read_background" = "${c.base07}1a";
          "editor.document_highlight.write_background" = "${c.base02}66";
          "terminal.background" = toHex c.base00;
          "terminal.foreground" = toHex c.base05;
          "terminal.bright_foreground" = toHex c.base07;
          "terminal.dim_foreground" = toHex c.base03;
          "terminal.ansi.black" = toHex c.base00;
          "terminal.ansi.bright_black" = toHex c.base03;
          "terminal.ansi.dim_black" = toHex c.base00;
          "terminal.ansi.red" = toHex c.base08;
          "terminal.ansi.bright_red" = toHex c.base08;
          "terminal.ansi.dim_red" = "${c.base08}bf";
          "terminal.ansi.green" = toHex c.base0B;
          "terminal.ansi.bright_green" = toHex c.base0B;
          "terminal.ansi.dim_green" = "${c.base0B}bf";
          "terminal.ansi.yellow" = toHex c.base07;
          "terminal.ansi.bright_yellow" = toHex c.base07;
          "terminal.ansi.dim_yellow" = "${c.base07}bf";
          "terminal.ansi.blue" = toHex c.base07;
          "terminal.ansi.bright_blue" = toHex c.base07;
          "terminal.ansi.dim_blue" = "${c.base07}bf";
          "terminal.ansi.magenta" = toHex c.base0E;
          "terminal.ansi.bright_magenta" = toHex c.base0E;
          "terminal.ansi.dim_magenta" = "${c.base0E}bf";
          "terminal.ansi.cyan" = toHex c.base0C;
          "terminal.ansi.bright_cyan" = toHex c.base0C;
          "terminal.ansi.dim_cyan" = "${c.base0C}bf";
          "terminal.ansi.white" = toHex c.base05;
          "terminal.ansi.bright_white" = toHex c.base07;
          "terminal.ansi.dim_white" = toHex c.base04;
          "link_text.hover" = toHex c.base07;
          "version_control.added" = toHex c.base0B;
          "version_control.modified" = toHex c.base07;
          "version_control.word_added" = "${c.base0B}59";
          "version_control.word_deleted" = "${c.base08}cc";
          "version_control.deleted" = toHex c.base08;
          "version_control.conflict_marker.ours" = "${c.base0B}1a";
          "version_control.conflict_marker.theirs" = "${c.base07}1a";
          conflict = toHex c.base07;
          "conflict.background" = "${c.base07}1a";
          "conflict.border" = "${c.base07}80";
          created = toHex c.base0B;
          "created.background" = "${c.base0B}1a";
          "created.border" = "${c.base0B}80";
          deleted = toHex c.base08;
          "deleted.background" = "${c.base08}1a";
          "deleted.border" = "${c.base08}80";
          error = toHex c.base08;
          "error.background" = "${c.base08}1a";
          "error.border" = "${c.base08}80";
          hidden = toHex c.base03;
          "hidden.background" = "${c.base02}1a";
          "hidden.border" = toHex c.base02;
          hint = toHex c.base0C;
          "hint.background" = "${c.base0C}1a";
          "hint.border" = "${c.base0C}80";
          ignored = toHex c.base03;
          "ignored.background" = "${c.base02}1a";
          "ignored.border" = toHex c.base02;
          info = toHex c.base07;
          "info.background" = "${c.base07}1a";
          "info.border" = "${c.base07}80";
          modified = toHex c.base07;
          "modified.background" = "${c.base07}1a";
          "modified.border" = "${c.base07}80";
          predictive = toHex c.base03;
          "predictive.background" = "${c.base03}1a";
          "predictive.border" = "${c.base03}80";
          renamed = toHex c.base07;
          "renamed.background" = "${c.base07}1a";
          "renamed.border" = "${c.base07}80";
          success = toHex c.base0B;
          "success.background" = "${c.base0B}1a";
          "success.border" = "${c.base0B}80";
          unreachable = toHex c.base04;
          "unreachable.background" = "${c.base03}1a";
          "unreachable.border" = toHex c.base03;
          warning = toHex c.base07;
          "warning.background" = "${c.base07}1a";
          "warning.border" = "${c.base07}80";
          players = [
            {
              cursor = toHex c.base07;
              background = "${c.base07}20";
              selection = "${c.base07}30";
            }
            {
              cursor = toHex c.base0E;
              background = "${c.base0E}20";
              selection = "${c.base0E}30";
            }
            {
              cursor = toHex c.base08;
              background = "${c.base08}20";
              selection = "${c.base08}30";
            }
            {
              cursor = toHex c.base09;
              background = "${c.base09}20";
              selection = "${c.base09}30";
            }
            {
              cursor = toHex c.base07;
              background = "${c.base07}20";
              selection = "${c.base07}30";
            }
            {
              cursor = toHex c.base0B;
              background = "${c.base0B}20";
              selection = "${c.base0B}30";
            }
            {
              cursor = toHex c.base0C;
              background = "${c.base0C}20";
              selection = "${c.base0C}30";
            }
            {
              cursor = toHex c.base0F;
              background = "${c.base0F}20";
              selection = "${c.base0F}30";
            }
          ];
          syntax = {
            attribute = {
              color = toHex c.base09;
              font_style = null;
              font_weight = null;
            };
            boolean = {
              color = toHex c.base09;
              font_style = null;
              font_weight = null;
            };
            comment = {
              color = toHex c.base03;
              font_style = null;
              font_weight = null;
            };
            "comment.doc" = {
              color = toHex c.base04;
              font_style = null;
              font_weight = null;
            };
            constant = {
              color = toHex c.base09;
              font_style = null;
              font_weight = null;
            };
            constructor = {
              color = toHex c.base07;
              font_style = null;
              font_weight = null;
            };
            embedded = {
              color = toHex c.base0F;
              font_style = null;
              font_weight = null;
            };
            emphasis = {
              color = toHex c.base0E;
              font_style = "italic";
              font_weight = null;
            };
            "emphasis.strong" = {
              color = toHex c.base07;
              font_style = null;
              font_weight = 700;
            };
            enum = {
              color = toHex c.base0C;
              font_style = null;
              font_weight = null;
            };
            function = {
              color = toHex c.base07;
              font_style = null;
              font_weight = null;
            };
            hint = {
              color = toHex c.base03;
              font_style = null;
              font_weight = null;
            };
            keyword = {
              color = toHex c.base0E;
              font_style = null;
              font_weight = null;
            };
            label = {
              color = toHex c.base08;
              font_style = null;
              font_weight = null;
            };
            link_text = {
              color = toHex c.base08;
              font_style = "normal";
              font_weight = null;
            };
            link_uri = {
              color = toHex c.base09;
              font_style = null;
              font_weight = null;
            };
            namespace = {
              color = toHex c.base07;
              font_style = null;
              font_weight = null;
            };
            number = {
              color = toHex c.base09;
              font_style = null;
              font_weight = null;
            };
            operator = {
              color = toHex c.base05;
              font_style = null;
              font_weight = null;
            };
            predictive = {
              color = toHex c.base03;
              font_style = "italic";
              font_weight = null;
            };
            preproc = {
              color = toHex c.base0F;
              font_style = null;
              font_weight = null;
            };
            primary = {
              color = toHex c.base05;
              font_style = null;
              font_weight = null;
            };
            property = {
              color = toHex c.base08;
              font_style = null;
              font_weight = null;
            };
            punctuation = {
              color = toHex c.base05;
              font_style = null;
              font_weight = null;
            };
            "punctuation.bracket" = {
              color = toHex c.base05;
              font_style = null;
              font_weight = null;
            };
            "punctuation.delimiter" = {
              color = toHex c.base05;
              font_style = null;
              font_weight = null;
            };
            "punctuation.list_marker" = {
              color = toHex c.base08;
              font_style = null;
              font_weight = null;
            };
            "punctuation.markup" = {
              color = toHex c.base08;
              font_style = null;
              font_weight = null;
            };
            "punctuation.special" = {
              color = toHex c.base0F;
              font_style = null;
              font_weight = null;
            };
            selector = {
              color = toHex c.base0E;
              font_style = null;
              font_weight = null;
            };
            "selector.pseudo" = {
              color = toHex c.base0C;
              font_style = null;
              font_weight = null;
            };
            string = {
              color = toHex c.base0B;
              font_style = null;
              font_weight = null;
            };
            "string.escape" = {
              color = toHex c.base0C;
              font_style = null;
              font_weight = null;
            };
            "string.regex" = {
              color = toHex c.base0C;
              font_style = null;
              font_weight = null;
            };
            "string.special" = {
              color = toHex c.base0C;
              font_style = null;
              font_weight = null;
            };
            "string.special.symbol" = {
              color = toHex c.base0B;
              font_style = null;
              font_weight = null;
            };
            tag = {
              color = toHex c.base08;
              font_style = null;
              font_weight = null;
            };
            "text.literal" = {
              color = toHex c.base0B;
              font_style = null;
              font_weight = null;
            };
            title = {
              color = toHex c.base07;
              font_style = null;
              font_weight = 700;
            };
            type = {
              color = toHex c.base07;
              font_style = null;
              font_weight = null;
            };
            variable = {
              color = toHex c.base08;
              font_style = null;
              font_weight = null;
            };
            "variable.special" = {
              color = toHex c.base09;
              font_style = null;
              font_weight = null;
            };
            variant = {
              color = toHex c.base07;
              font_style = null;
              font_weight = null;
            };
          };
        };
      }
    ];
  };
in {
  xdg.configFile."gram/themes/custom.json".text = builtins.toJSON theme;
}
