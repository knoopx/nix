{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./openssh.nix
    ./klipper.nix
  ];

  hardware = {
    enableRedistributableFirmware = false;
    firmware = [pkgs.raspberrypiWirelessFirmware];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4128;
    }
  ];

  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_5_10;
    kernelModules = ["bcm2835-v4l2"];
    kernelParams = ["cma=256M"];
    extraModprobeConfig = ''
      options cf680211 ieee80211_regdom="US"
    '';
    initrd.kernelModules = ["vc4" "bcm2835_dma" "i2c_bcm2835"];
  };

  networking = {
    hostName = "bear";
    useDHCP = false; #deprecated
    interfaces.eth0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    wireless = {
      interfaces = ["wlan0"];
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    htop
    vim
    tmux
    libraspberrypi
    (callPackage ./klipper-firmware {}).klipper-firmware
    (callPackage ./klipper-firmware {}).klipper-flash
  ];

  services.moonraker = {
    user = "root";
    enable = true;
    address = "0.0.0.0";
    settings = {
      octoprint_compat = {};
      history = {};
      authorization = {
        force_logins = true;
        cors_domains = [
          "*.local"
          "*.lan"
          "*://app.fluidd.xyz"
          "*://my.mainsail.xyz"
        ];
        trusted_clients = [
          "10.0.0.0/8"
          "127.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.1.0/24"
          "FE80::/10"
          "::1/128"
        ];
      };
    };
  };

  services.fluidd.enable = true;
  services.fluidd.nginx.locations."/webcam".proxyPass = "http://127.0.0.1:8080/stream";
  # Increase max upload size for uploading .gcode files from PrusaSlicer
  services.nginx.clientMaxBodySize = "1000m";

  systemd.services.ustreamer = {
    wantedBy = ["multi-user.target"];
    description = "uStreamer for video0";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.ustreamer}/bin/ustreamer --encoder=HW --persistent --drop-same-frames=30'';
    };
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?s
}
