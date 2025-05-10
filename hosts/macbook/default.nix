{
  pkgs,
  config,
  ...
} @ inputs: let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;

  system = "x86_64-linux";
  apple-ib-driver =
    pkgs.callPackage ./apple-ib-drv.nix
    {
      kernel = config.boot.kernelPackages.kernel;
    };
in {
  imports =
    [
      ./hardware.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  networking.hostName = "macbook";
  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "gccarch-rocketlake"
    "gccarch-x86-64-v3"
    "gccarch-x86-64-v4"
  ];

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";

  # https://bugzilla.kernel.org/show_bug.cgi?id=193121
  # ccode=0,regrev=0
  # brcmfmac43602-pcie.bin

  environment.systemPackages = with pkgs; [
    (
      pkgs.stdenv.mkDerivation {
        name = "brcmfmac43602-pcie.txt";
        phases = ["installPhase"];
        installPhase = ''
          mkdir -p $out/lib/firmware/brcm
          cp ${./brcmfmac43602-pcie.txt} $out/lib/firmware/brcm/
        '';
      }
    )
    apple-ib-drv
  ];

  boot.extraModulePackages = with pkgs; [apple-ib-drv];
}
