{nixosConfig, ...}: let
  palette = nixosConfig.defaults.colorScheme.palette;
in {
  xdg.configFile."wl-kbptr/config".text = ''
    [mode_floating]
    source=detect
    label_color=#${palette.base05}ff
    label_select_color=#${palette.base0D}ff
    unselectable_bg_color=#${palette.base02}cc
    selectable_bg_color=#${palette.base04}cc
    selectable_border_color=#${palette.base05}33
    label_font_family=${nixosConfig.defaults.fonts.monospace.name}
    label_font_size=12 50% 100
    label_symbols=abcdefghijklmnopqrstuvwxyz
  '';
}
