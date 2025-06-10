{
  defaults,
  lib,
  pkgs,
  modulesPath,
  ...
} @ inputs: let
  system = "x86_64-linux";
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
in {
  imports =
    [
      "${modulesPath}/profiles/qemu-guest.nix"
      "${modulesPath}/virtualisation/qemu-vm.nix"
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  networking.hostName = "vm";

  system = {
    stateVersion = "25.05";
  };

  virtualisation.memorySize = 4096;
  virtualisation.cores = 8;
  virtualisation.resolution.x = 1920;
  virtualisation.resolution.y = 1080;
  virtualisation.qemu.options = [
    "-vga none"
    "-device virtio-vga-gl"
    "-display gtk,gl=on"
    "-device usb-tablet"
    "-device usb-kbd"
  ];

  # Enable spice agent for better VM integration
  services.spice-vdagentd.enable = true;

  # Ensure proper input kernel modules are loaded
  boot.kernelModules = ["uinput" "evdev"];

  virtualisation.forwardPorts = [
    {
      from = "host";
      host.port = 2222;
      guest.port = 22;
    }
  ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = defaults.username;
  services.displayManager.gdm.enable = lib.mkForce false;

  # Configure proper display manager for niri
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
      initial_session = {
        command = "niri-session";
        user = defaults.username;
      };
    };
  };

  # home-manager.users.${defaults.username} = {
  #   programs.niri.settings = {
  #     spawn-at-startup = [
  #       {command = ["nautilus"];}
  #       # {command = ["kitty" "bash" "${./demo.sh}"];}
  #     ];

  #     outputs."Virtual-1" = {
  #       scale = 2.0;
  #       background-color = "#${defaults.colorScheme.palette.base02}";
  #     };
  #   };
  # };

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };
}
