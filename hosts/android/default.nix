{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "android";

  avf.defaultUser = "knoopx";
  avf.enableGraphics = false;

  system.stateVersion = "25.05";

  nixpkgs.hostPlatform = "aarch64-linux";

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  security.sudo.wheelNeedsPassword = false;

  users.users.knoopx = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    initialHashedPassword = "";
    openssh.authorizedKeys.keyFiles = [
      (pkgs.fetchurl {
        url = "https://github.com/knoopx.keys";
        sha256 = "sha256-+NTzRTwtXfCJvO+YJdIByVowK9uof/MvHpoYyqwIHiA=";
      })
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    # essentials
    curl
    wget
    btop
    ripgrep
    fd
    jq
    tree
    file
    _7zz
    p7zip
    unzip
    zip
    lsof
    util-linux
    findutils

    # networking
    inetutils
    socat
    aria2
    w3m

    # development
    helix
    tmux
    git
    jujutsu
    gh
    jq
    python3
    bun
    duckdb

    # file management
    rsync
    fclones
    exiftool
  ];

  # shared storage aliases
  environment.shellAliases = {
    shared = "cd /mnt/shared";
    internal = "cd /mnt/internal";
  };

  # mDNS for easy access (ssh knoopx@android.local)
  services.avahi = {
    publish.addresses = true;
  };

  programs.fish.enable = true;
  users.users.knoopx.shell = pkgs.fish;
}
