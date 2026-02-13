{
  config,
  lib,
  pkgs,
  modulesPath,
  targetSystem,
  ...
}: let
  system = "x86_64-linux";

  # Unattended installer script
  # Based on: https://gitlab.com/misuzu/nixos-unattended-install-iso/
  installer = pkgs.writeShellApplication {
    name = "installer";
    runtimeInputs = with pkgs; [
      dosfstools
      e2fsprogs
      gawk
      nixos-install-tools
      util-linux
      xfsprogs
      config.nix.package
    ];
    text = ''
      set -euo pipefail

      echo "============================================"
      echo "       kOS Unattended Installer"
      echo "============================================"
      echo ""
      echo "Setting up disks..."

      DEVICE_MAIN=""
      for i in $(lsblk -pln -o NAME,TYPE | grep disk | awk '{ print $1 }'); do
        if [[ "$i" == "/dev/fd0" ]]; then
          echo "  $i is a floppy, skipping..."
          continue
        fi
        if grep -ql "^$i" <(mount); then
          echo "  $i is in use, skipping..."
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

      export DISKO_DEVICE_MAIN
      DISKO_DEVICE_MAIN=''${DEVICE_MAIN#"/dev/"}
      ${targetSystem.config.system.build.diskoScript} 2> /dev/null

      echo ""
      echo "Installing the system..."
      echo ""

      nixos-install \
        --no-channel-copy \
        --no-root-password \
        --option substituters "" \
        --system ${targetSystem.config.system.build.toplevel}

      echo ""
      echo "============================================"
      echo "       Installation Complete!"
      echo "============================================"
      echo ""
      echo "The system will reboot in 5 seconds..."
      sleep 5
      reboot
    '';
  };

  installerFailsafe = pkgs.writeShellScript "installer-failsafe" ''
    ${lib.getExe installer} || {
      echo ""
      echo "============================================"
      echo "       Installation FAILED!"
      echo "============================================"
      echo ""
      echo "Press Ctrl+Alt+Del to reboot or wait..."
    }
    sleep 3600
  '';
in {
  nixpkgs.hostPlatform = system;

  imports = [
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    (modulesPath + "/profiles/all-hardware.nix")
  ];

  # Basic networking for the installer
  networking.hostName = "installer";
  networking.hostId = "67faa5a0";

  # ISO configuration
  image.fileName = "kOS-installer-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  isoImage.squashfsCompression = "zstd -Xcompression-level 15";
  isoImage.volumeID = "KOS_INSTALLER";

  # Quiet boot for cleaner installer experience
  boot.kernelParams = ["quiet" "systemd.unit=getty.target"];
  boot.supportedFilesystems.zfs = lib.mkForce true;
  boot.initrd.systemd.enable = true;

  # System state version
  system.stateVersion = lib.mkDefault lib.trivial.release;

  # Auto-start installer on tty1
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      ExecStart = ["" installerFailsafe];
      Restart = "no";
      StandardInput = "null";
    };
  };

  # Include useful tools for debugging
  environment.systemPackages = with pkgs; [
    vim
    htop
    parted
    gptfdisk
  ];
}
