{pkgs, ...}: {
  programs = {
    fish.enable = true;
    command-not-found = {
      enable = true;
    };
  };
}
