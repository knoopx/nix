{config, ...} @ inputs: let
  system = "x86_64-linux";
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
in {
  imports =
    [
      ./boot.nix
      ./filesystems.nix
      ./hardware.nix
      ./nvidia.nix
      ./services.nix
    ]
    ++ (listNixModulesRecusive ./services)
    ++ (listNixModulesRecusive ./containers)
    ++ (listNixModulesRecusive ../../modules/nixos);

  networking.hostName = "desktop";
  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "gccarch-rocketlake"
    "gccarch-x86-64-v3"
    "gccarch-x86-64-v4"
  ];

  system = {
    stateVersion = "24.05";
  };

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
    config = {
      cudaSupport = true;
    };
  };

  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;

  defaults.display.appWidths = {
    "io.bassi.Amberol" = 0.25;
    "kitty" = 0.5;
    "net.knoopx.bookmarks" = 0.25;
    "net.knoopx.chat" = 0.5;
    "net.knoopx.launcher" = 0.25;
    "net.knoopx.music" = 0.33;
    "net.knoopx.nix-packages" = 0.25;
    "net.knoopx.notes" = 0.75;
    "net.knoopx.process-manager" = 0.25;
    "net.knoopx.scratchpad" = 0.25;
    "net.knoopx.windows" = 0.25;
    "org.gnome.Calendar" = 0.75;
    "org.gnome.Weather" = 0.75;
    "Plexamp" = 0.25;
    "transmission-gtk" = 0.5;
  };
}
