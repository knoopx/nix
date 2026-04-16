{ nixosConfig, ... }: {
  programs.kitty = {
    enable = true;

    settings = {
      active_tab_font_style = "bold";
      confirm_os_window_close = 0;
      cursor_shape = "block";
      enabled_layouts = "splits,stack";
      font_size = 10;
      hide_window_decorations = "yes";
      tab_bar_edge = "top";
      tab_bar_margin_width = 5;
      tab_bar_style = "separator";
      window_padding_width = 10;
    };

    extraConfig = with nixosConfig.defaults.colorScheme.palette; ''
      map ctrl+backspace send_text all \x17
      # Toggle a temporary bottom panel (preserves session across toggle)
      map ctrl+shift+enter remote_control_script toggle-panel.sh
      map ctrl+shift+n new_os_window_with_cwd
      map ctrl+shift+t new_tab_with_cwd
      mouse_map ctrl+shift+left press ungrabbed,grabbed mouse_selection rectangle

      # Window navigation
      map ctrl+shift+up neighboring_window top
      map ctrl+shift+down neighboring_window bottom
      map ctrl+shift+left neighboring_window left
      map ctrl+shift+right neighboring_window right

      # unbind defaults
      map ctrl+shift+l ungrabbed
      map ctrl+shift+p ungrabbed
      map ctrl+shift+left ungrabbed
      map ctrl+shift+right ungrabbed
      map ctrl+shift+f ungrabbed

      tab_separator " "
      tab_title_template " {fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title} "
      active_tab_foreground #${base00}
      active_tab_background #${base0D}
      inactive_tab_background #${base00}
      tab_bar_background #${base00}
    '';
  };

  xdg.configFile."kitty/toggle-panel.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      state="''${XDG_RUNTIME_DIR:-/tmp}/kitty-panel-open"

      if ! kitten @ ls 2>/dev/null | grep -q '"title": "panel"'; then
        # No panel - create and focus it
        kitten @ launch --location=hsplit --cwd=current --title=panel
        touch "$state"
      elif [ -f "$state" ]; then
        # Panel is visible - hide it (preserves session)
        kitten @ focus-window --match 'not title:panel' 2>/dev/null
        kitten @ action toggle_layout stack
        rm -f "$state"
      else
        # Panel is hidden - show and focus it
        kitten @ action toggle_layout stack
        kitten @ focus-window --match title:panel
        touch "$state"
      fi
    '';
  };
}
