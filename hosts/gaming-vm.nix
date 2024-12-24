{pkgs, ...}: let
  username = "gaming";

  launchbox-metadata = fetchTarball {
    url = "http://gamesdb.launchbox-app.com/Metadata.zip";
    sha256 = "";
  };
in {
  environment.defaultPackages = [];
  documentation.enable = false;
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
  networking.hostName = "gaming-vm";

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
      user = username;
    };
  };

  programs.fish.enable = true;
  # programs.home-manager.enable = true;

  users.users.${username} = {
    # isSystemUser = true;
    isNormalUser = true;
    initialPassword = username;

    shell = pkgs.fish;
    # extraGroups = ["wheel" "networkmanager" "audio" "video" "docker" "lxd" "kvm" "libvirtd" "qemu-libvirtd"];

    packages = with pkgs; [
      pegasus-frontend
      cemu
      retroarchFull
      ryujinx
      umu
      gamemode
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {};

    users.${username} = {
      home = {
        stateVersion = "25.05";
      };

      home.file."roms/test/metadata.txt".text = ''
        collection: Test
        launcher: /etc/profiles/per-user/${username}/bin/retroarch -L /etc/profiles/per-user/${username}/lib/retroarch/cores/flycast_libretro.so {file.path}

        game: Test
        filename: test.txt
      '';

      home.file."roms/test/test.txt".text = "Hello World";

      xdg.configFile."pegasus-frontend/settings.txt".text = ''
        general.theme: themes/gameOS/
        general.verify-files: false
        general.input-mouse-support: true
        general.fullscreen: true
        providers.pegasus_media.enabled: true
        providers.steam.enabled: true
        providers.gog.enabled: true
        providers.es2.enabled: true
        providers.logiqx.enabled: true
        providers.lutris.enabled: true
        providers.skraper.enabled: true
        keys.page-up: PgUp,GamepadL2
        keys.page-down: PgDown,GamepadR2
        keys.prev-page: Q,A,GamepadL1
        keys.next-page: E,D,GamepadR1
        keys.menu: F1,GamepadStart
        keys.filters: F,GamepadY
        keys.details: I,GamepadX
        keys.cancel: Esc,Backspace,GamepadB
        keys.accept: Return,Enter,GamepadA
      '';

      xdg.configFile."pegasus-frontend/game_dirs.txt".text = ''
        /home/${username}/roms/test
      '';

      xdg.configFile."pegasus-frontend/themes/gameOS" = {
        source = fetchTarball {
          url = "https://github.com/PlayingKarrde/gameOS/releases/download/1.10/gameOS.zip";
          sha256 = "sha256:1ph487fnl7ayn5fgzb381fnzw2daj09r7q6hy0papaq579i1knsf";
        };
        recursive = true;
      };
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = true;
    };
  };
}
