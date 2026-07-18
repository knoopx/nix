{ lib, ... }: {
  services.power-profiles-daemon.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = lib.mkForce "yes";
      PasswordAuthentication = false;
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      minibook = {
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
