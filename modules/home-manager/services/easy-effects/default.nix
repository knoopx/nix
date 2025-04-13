{
  defaults,
  config,
  ...
}: let
  irs = fetchTarball {
    url = "file://${toString ./irs.zip}";
    sha256 = "sha256:0lryansmrm9a0d364gmw9grrb1jzkxjy3y7ybi7simbny4h01s11";
  };
in {
  xdg.configFile."easyeffects/irs/" = {
    source = irs;
    recursive = true;
  };

  dconf.settings = {
    "com/github/wwmm/easyeffects/streamoutputs/convolver" = {
      kernel-path = "${config.home.homeDirectory}/.config/easyeffects/irs/${defaults.easyeffects.irs}.irs";
    };
  };

  services = {
    easyeffects = {
      enable = true;
    };
  };
}
