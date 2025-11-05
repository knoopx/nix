{...}: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        # nix run nixpkgs#keyd monitor
        ids = ["*"];
        settings = {
          main = {
            leftmeta = "overload(meta, M-.)";
          };
        };
      };
    };
  };
}
