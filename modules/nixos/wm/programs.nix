_: {
  programs.xwayland.enable = true;
  programs.ydotool.enable = true;
  programs.dconf.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "wezterm";
  };
}
