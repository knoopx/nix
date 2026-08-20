{ nixosConfig
, lib
, pkgs
, ...
}: {
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
      allow_remote_control = true;
      listen_on = "unix:@kitty";
    };

    extraConfig = with nixosConfig.defaults.colorScheme.palette; ''
      map ctrl+backspace send_text all \x17
      # Toggle a temporary bottom panel (preserves session across toggle)
      map ctrl+shift+enter remote_control_script ${lib.getExe pkgs.toggle-panel}
      map ctrl+shift+n new_os_window_with_cwd
      map ctrl+shift+t new_tab_with_cwd
      mouse_map ctrl+shift+left press ungrabbed,grabbed mouse_selection rectangle

      # Window navigation
      map ctrl+shift+up neighboring_window top
      map ctrl+shift+down neighboring_window bottom
      map ctrl+shift+left neighboring_window left
      map ctrl+shift+right neighboring_window right

      # Tab navigation
      map ctrl+shift+page_up previous_tab
      map ctrl+shift+page_down next_tab

      # Page scroll
      map ctrl+page_up scroll_page_up
      map ctrl+page_down scroll_page_down

      # unbind defaults
      map ctrl+backspace ungrabbed
      map ctrl+shift+f ungrabbed
      map ctrl+shift+j ungrabbed
      map ctrl+shift+k ungrabbed
      map ctrl+shift+l ungrabbed
      map ctrl+shift+left ungrabbed
      map ctrl+shift+p ungrabbed
      map ctrl+shift+r ungrabbed
      map ctrl+shift+right ungrabbed
      map ctrl+w ungrabbed
      

      tab_separator " "
      tab_title_template " {fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title} "
      active_tab_foreground #${base00}
      active_tab_background #${base0D}
      inactive_tab_background #${base00}
      tab_bar_background #${base00}
    '';
  };
}
