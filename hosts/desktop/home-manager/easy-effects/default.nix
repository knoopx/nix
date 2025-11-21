{config, ...}: let
  default-irs = "MaxxAudio Pro ((128K MP3)) 4.Music w MaxxSpace";
  irs = fetchTarball {
    url = "file://${toString ./irs.zip}";
    sha256 = "sha256:0lryansmrm9a0d364gmw9grrb1jzkxjy3y7ybi7simbny4h01s11";
  };
in {
  xdg.configFile."easyeffects/irs/" = {
    source = irs;
    recursive = true;
  };

  xdg.configFile."easyeffects/db/convolverrc" = {
    text = ''
      [soe][Convolver#0]
      kernelName=${default-irs}
    '';
  };

  services = {
    easyeffects = {
      enable = true;
    };
  };
}
