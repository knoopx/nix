{modulesPath, ...} @ inputs: let
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
    stateVersion = "24.05";
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

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };
}
