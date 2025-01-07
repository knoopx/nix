{
  pkgs,
  config,
  ...
}: let
in {
  imports = [
    ../modules/nixos/headless/theming
  ];

  environment.defaultPackages = [];
  documentation.enable = false;
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
  networking.hostName = "jegos";

  services = {
    printing.enable = false;
    pipewire.enable = true;

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };

    cage = {
      enable = true;
      program = "${pkgs.pegasus-frontend}/bin/pegasus-fe";
      user = "jegos";
    };
  };

  programs.fish.enable = true;
  # programs.home-manager.enable = true;

  users.users.jegos = {
    # isSystemUser = true;
    isNormalUser = true;
    initialPassword = "jegos";

    shell = pkgs.fish;
    # extraGroups = ["wheel" "networkmanager" "audio" "video" "docker" "lxd" "kvm" "libvirtd" "qemu-libvirtd"];

    packages = with pkgs; [
      # umu
      pegasus-frontend
      cemu
      # retroarchFull
      ryujinx
      # gamemode
    ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = true;
    };
  };
}
