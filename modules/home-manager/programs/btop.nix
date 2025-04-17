{...}: {
  programs.btop = {
    enable = true;
    settings = {
      presets = "cpu:0:default,net:0:tty,proc:1:default";
    };
  };
}
