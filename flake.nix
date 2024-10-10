{
  description = "kOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    chaotic.inputs.nixpkgs.follows = "nixpkgs";
    chaotic.inputs.home-manager.follows = "home-manager";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
  };

  outputs = {
    self,
    stylix,
    chaotic,
    nixpkgs,
    home-manager,
    nix-colors,
    ...
  } @ inputs: let
    inherit (self) outputs;
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    colorScheme =
      pkgs.lib.attrsets.recursiveUpdate
      nix-colors.colorSchemes.catppuccin-mocha
      {
        palette.base0E = "fad000";
      };

    username = "knoopx";

    defaults = {
      inherit colorScheme;

      # cat $(nix-build --no-out-link '<nixpkgs>' -A xkeyboard_config)/etc/X11/xkb/rules/base.lst
      keyMap = "eu";
      timeZone = "Europe/Madrid";
      defaultLocale = "en_US.UTF-8";
      region = "es_ES.UTF-8";

      full-name = "Victor Martinez";

      avatar-image =
        (pkgs.fetchurl {
          url = "https://gravatar.com/userimage/10402619/9d663d9a46ad2c752bf6cfeb93cff4fd.jpeg?size=512";
          sha256 = "sha256-raMsbyJQgf7JPMvZtAFOBIBwFg8V7HpmtERO9J/50qQ=";
        })
        .outPath;

      primary-email = "knoopx@gmail.com";
      work-email = "victor@jacoti.com";

      editor = "re.sonny.Commit";

      pubKeys = {
        url = "https://github.com/${username}.keys";
        sha256 = "sha256-385krE9Aoea23aQ3FJo2kpPtRrIOwxxXCCt43gHEo0Q=";
      };

      inherit username;
      password = username;

      easyeffects = {
        irs = "MaxxAudio Pro 128K MP3 4.Music w MaxxSpace";
      };

      # fc-list : family
      fonts = {
        sizes.applications = 11;

        sansSerif = {
          name = "Inter";
          package = pkgs.inter;
        };

        serif = {
          name = "Roboto Slab";
          package = pkgs.roboto;
        };

        emoji = {
          # name = "Noto Color Emoji";
          # package = pkgs.noto-fonts-color-emoji;
          name = "Twitter Color Emoji";
          package = pkgs.twitter-color-emoji;
        };

        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        };
      };

      display = {
        width = 1920 * 2;
        height = 1080 * 2;
      };

      gnome = {
        windowSize = [1240 900];
        sidebarWidth = 200;
        extensions = with pkgs.gnomeExtensions; [
          hot-edge
          user-themes
          caffeine
          panel-corners
          astra-monitor
          # tailscale-qs
        ];
      };
    };

    specialArgs = {inherit inputs outputs defaults stylix;};

    homeManagerConfig = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = specialArgs;
      backupFileExtension = "bak";
      users.${defaults.username} = import ./home/${defaults.username}.nix;
    };

    nixosModules = [
      {home-manager = homeManagerConfig;}
      chaotic.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
    ];
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/desktop.nix
          ];
      };

      desktop-vm = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/desktop-vm.nix
          ];
      };

      # https://www.reddit.com/r/NixOS/comments/y1xo2u/how_to_create_an_iso_with_my_config_files/
      live = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          inputs.stylix.nixosModules.stylix
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
          ./hosts/live.nix
        ];
      };
    };

    homeConfigurations = {
      "${defaults.username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          ./home/knoopx.nix
        ];
      };
    };
  };
}
