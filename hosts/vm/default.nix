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
  virtualisation.qemu.options = ["-vga none" "-device virtio-vga-gl" "-display gtk,gl=on"];

  virtualisation.forwardPorts = [
    {
      from = "host";
      host.port = 2222;
      guest.port = 22;
    }
  ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = defaults.username;
  services.xserver.displayManager.gdm.enable = lib.mkForce false;

  home-manager.users.${defaults.username} = {
    programs.niri.settings = {
      spawn-at-startup = [
        {command = ["kitty" "bash" "${./demo.sh}"];}
      ];

      outputs."Virtual-1" = {
        scale = 2.0;
        background-color = "#${defaults.colorScheme.palette.base02}";
      };
    };
  };

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };
}
