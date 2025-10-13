{
  config,
  lib,
  ...
} @ inputs: let
  system = "x86_64-linux";
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
in {
  imports =
    [
      ./boot.nix
      ./filesystems.nix
      ./hardware.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  networking.hostName = "zbook";
  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "gccarch-zen5"
    "gccarch-x86-64-v3"
    "gccarch-x86-64-v4"
  ];

  system = {
    stateVersion = "25.05";
  };

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
    config = {
      cudaSupport = true;
    };
  };

  home-manager.users.${config.defaults.username} = {
    imports = [../../home/${config.defaults.username}.nix];
  };

  defaults.display.appWidths = {
    "code" = 1.0;
    "io.bassi.Amberol" = 0.25;
    "kitty" = 0.75;
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

  #   defaults = {
  #     # https://github.com/tinted-theming/schemes
  #     colorScheme = lib.mkForce {
  #       name = "custom";
  #       palette = {
  #         base00 = "2c1616";
  #         base01 = "452121";
  #         base02 = "743939";
  #         base03 = "884444";
  #         base04 = "a75858";
  #         base05 = "e3c9c9";
  #         base06 = "e1cbcb";
  #         base07 = "fad000";
  #         base08 = "da5353";
  #         base09 = "da4949";
  #         base0A = "ffee80";
  #         base0B = "de7d7d";
  #         base0C = "dd6f6f";
  #         base0D = "fad000";
  #         base0E = "faefa5";
  #         base0F = "df8080";
  #      };
  #    };
  #  };
}
