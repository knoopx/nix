{pkgs, ...}: {
  programs = {
    fish.enable = true;
    command-not-found = {
      enable = true;
    };

    fzf.fuzzyCompletion = true;
    # nh = {
    #   enable = true;
    #   clean.enable = true;
    #   clean.extraArgs = "--keep-since 4d --keep 3";
    #   flake = "/home/user/my-nixos-config";
    # };
  };
}
