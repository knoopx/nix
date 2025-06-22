{
  description = "kOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs?rev=5395fb3ab3f97b9b7abca147249fa2e8ed27b192";

    ollamark.url = "github:knoopx/ollamark";
    ollamark.inputs.nixpkgs.follows = "nixpkgs";

    vibeapps.url = "github:knoopx/vibeapps";
    vibeapps.inputs.nixpkgs.follows = "nixpkgs";

    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    niri.url = "github:YaLTeR/niri";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    xwayland-satellite.url = "github:Supreeeme/xwayland-satellite";
    xwayland-satellite.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";

    astal-shell.url = "github:knoopx/astal-shell";
    astal-shell.inputs.nixpkgs.follows = "nixpkgs";
    astal-shell.inputs.ags.follows = "ags";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin-userstyles.url = "github:catppuccin/userstyles";
    catppuccin-userstyles.flake = false;

    firefox-gnome-theme.url = "github:rafaelmardojai/firefox-gnome-theme";
    firefox-gnome-theme.flake = false;

    betterfox.url = "github:yokoffing/BetterFox";
    betterfox.flake = false;

    adwaita-colors.url = "github:dpejoh/Adwaita-colors";
    adwaita-colors.flake = false;

    neuwaita.url = "github:RusticBard/Neuwaita";
    neuwaita.flake = false;

    autofirma-nix.url = "github:nix-community/autofirma-nix";
    autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";
    autofirma-nix.inputs.home-manager.follows = "home-manager";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {
    firefox-addons,
    haumea,
    home-manager,
    nixpkgs,
    stylix,
    niri,
    xwayland-satellite,
    vibeapps,
    ollamark,
    astal-shell,
    autofirma-nix,
    nixos-hardware,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    specialArgs =
      (nixpkgs.lib.removeAttrs inputs ["self"])
      // {
        inherit inputs;
      };

    haumeaInputs = prev:
      specialArgs
      // {
        pkgs = prev;
        inherit (nixpkgs) lib;
      };

    globalOverlays =
      [
        ollamark.overlays.default
        astal-shell.overlays.default
        (self: super: vibeapps.packages.${system})
        (self: super: {niri = niri.packages.${system}.default;})
        (self: super: {xwayland-satellite = xwayland-satellite.packages.${system}.default;})
        (
          self: super: {firefox-addons = firefox-addons.packages.${system};}
        )
        (
          final: prev:
            haumea.lib.load {
              src = ./pkgs;
              loader = haumea.lib.loaders.scoped;
              inputs =
                haumeaInputs prev;
            }
        )
        (
          final: prev: {
            lib =
              prev.lib.extend
              (p: x: (haumea.lib.load {
                src = ./lib;
                inputs = haumeaInputs prev;
              }));
          }
        )
        (
          final: prev:
            haumea.lib.load {
              src = ./builders;
              inputs = haumeaInputs prev;
            }
        )
      ]
      ++ (nixpkgs.lib.attrsets.attrValues (haumea.lib.load {
        src = ./overlays;
        loader = haumea.lib.loaders.verbatim;
      }));

    mkNixosModules = hostPath: let
      hostOverlaysPath = hostPath + "/overlays.nix";
      hostOverlays =
        if builtins.pathExists hostOverlaysPath
        then [(import hostOverlaysPath)]
        else [];
    in [
      ./modules/nixos/defaults.nix
      {
        nixpkgs.overlays = globalOverlays ++ hostOverlays;
      }
      stylix.nixosModules.stylix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
          backupFileExtension = "bak";
          sharedModules = [
            vibeapps.homeManagerModules.default
            autofirma-nix.homeManagerModules.default
          ];
        };
      }
      hostPath
    ];
    vmConfiguration = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = mkNixosModules ./hosts/vm;
    };

    # Create pkgs with overlays for package exports
    pkgsWithOverlays = import nixpkgs {
      inherit system;
      overlays = globalOverlays;
    };
  in {
    packages.${system} = {
      default = vmConfiguration.config.system.build.vm;

      # Repository packages
      importantize = pkgsWithOverlays.importantize;
      neuwaita-icon-theme = pkgsWithOverlays.neuwaita-icon-theme;
      nfoview = pkgsWithOverlays.nfoview;
      strip-python-comments = pkgsWithOverlays.strip-python-comments;
    };

    nixosConfigurations = {
      vm = vmConfiguration;

      live-usb = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = mkNixosModules ./hosts/live-usb;
      };

      desktop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = mkNixosModules ./hosts/desktop;
      };

      minibookx = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          (mkNixosModules ./hosts/minibookx)
          ++ [
            nixos-hardware.nixosModules.chuwi-minibook-x
          ];
      };
    };
    # homeConfigurations = {
    #   "${username}" = home-manager.lib.homeManagerConfiguration {
    #     inherit pkgs;
    #     extraSpecialArgs = specialArgs;
    #     modules = [
    #       vibeapps.homeManagerModules.default
    #       ./home/knoopx
    #     ];
    #   };
    # };
  };
}
