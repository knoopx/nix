{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
} @ inputs: let
  system = "x86_64-linux";
  targetSystem = inputs.targetSystem;

  # https://gitlab.com/misuzu/nixos-unattended-install-iso/

  installer = pkgs.writeShellApplication {
    name = "installer";
    runtimeInputs = with pkgs; [
      dosfstools
      e2fsprogs
      gawk
      nixos-install-tools
      util-linux
      config.nix.package
    ];
    text = ''
      set -euo pipefail

      echo "Setting up disks..."
      for i in $(lsblk -pln -o NAME,TYPE | grep disk | awk '{ print $1 }'); do
        if [[ "$i" == "/dev/fd0" ]]; then
          echo "$i is a floppy, skipping..."
          continue
        fi
        if grep -ql "^$i" <(mount); then
          echo "$i is in use, skipping..."
        else
          DEVICE_MAIN="$i"
          break
        fi
      done
      if [[ -z "$DEVICE_MAIN" ]]; then
        echo "ERROR: No usable disk found on this machine!"
        exit 1
      else
        echo "Found $DEVICE_MAIN, erasing..."
      fi

      DISKO_DEVICE_MAIN=''${DEVICE_MAIN#"/dev/"} ${targetSystem.config.system.build.diskoScript} 2> /dev/null

      echo "Installing the system..."

      nixos-install --no-channel-copy --no-root-password --option substituters "" --system ${targetSystem.config.system.build.toplevel}

      echo "Done! Rebooting..."
      sleep 3
      reboot
    '';
  };
  installerFailsafe = pkgs.writeShellScript "failsafe" ''
    ${lib.getExe installer} || echo "ERROR: Installation failure!"
    sleep 3600
  '';
in {
  nixpkgs.hostPlatform = system;
  imports = [
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    (modulesPath + "/profiles/all-hardware.nix")
  ];

  # Pass the target system to the installer
  _module.args.targetSystem = targetSystem;

  # Basic networking
  networking.hostId = "67faa5a0";

  # ISO configuration
  image.fileName = "kOS-installer-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  isoImage.squashfsCompression = "zstd -Xcompression-level 15";

  # Quiet boot
  boot.kernelParams = ["quiet" "systemd.unit=getty.target"];
  boot.supportedFilesystems.zfs = true;
  boot.initrd.systemd.enable = true;

  # System state
  system.stateVersion = lib.mkDefault lib.trivial.release;

  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      ExecStart = ["" installerFailsafe];
      Restart = "no";
      StandardInput = "null";
    };
  };
}
