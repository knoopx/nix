{nixosConfig, ...}: {
  programs.kitty = {
    enable = true;

    settings = {
      active_tab_font_style = "bold";
      confirm_os_window_close = 0;
      cursor_shape = "block";
      font_size = 10;
      hide_window_decorations = "yes";
      tab_bar_edge = "top";
      tab_bar_margin_width = 5;
      tab_bar_style = "separator";
      window_padding_width = 10;
    };

    extraConfig = with nixosConfig.defaults.colorScheme.palette; ''
      map ctrl+shift+enter new_window_with_cwd
      map ctrl+shift+t new_tab_with_cwd

      tab_separator " "
      tab_title_template " {fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title} "
      active_tab_foreground #${base00}
      active_tab_background #${base0D}
      inactive_tab_background #${base00}
      tab_bar_background #${base00}
    '';
  };
}
