{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;
    settings = {
      presets = "cpu:0:default,net:0:tty,proc:1:default";
    };
  };
}
