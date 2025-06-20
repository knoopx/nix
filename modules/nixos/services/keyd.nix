{...}: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        # nix run nixpkgs#keyd monitor
        ids = ["*"];
        settings = {
          main = {
            meta = "overload(meta, M-.)";
          };
        };
      };
    };
  };
}
