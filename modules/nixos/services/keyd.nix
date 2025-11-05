{...}: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        # nix run nixpkgs#keyd monitor
        ids = ["*"];
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
