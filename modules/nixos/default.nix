{config, ...}: {
  imports = [
    ./hardware.nix
    ./networking.nix
    ./nix-ld.nix
    ./nix.nix
    ./overlays.nix
    ./nixpkgs.nix
    ./packages.nix
    ./services.nix
    ./system.nix
    ./theming
    ./users.nix
    ./virtualisation.nix
  ];

  documentation.enable = false;

  programs = {
    fish.enable = true;

    command-not-found = {
      enable = true;
    };

    fzf.fuzzyCompletion = true;
    skim.fuzzyCompletion = true;
  };
}
