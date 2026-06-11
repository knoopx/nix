{ ... }: {
  services.power-profiles-daemon.enable = true;

  services.keyd = {
    enable = true;
    keyboards = {
      hi10max = {
        ids = [ "0001:0001" ];
        settings = {
          main = {
            leftalt = "overload(meta, M-.)";
            leftmeta = "leftalt";
          };
        };
      };
    };
  };
}
