{
  description = "kOS";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs";

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

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    minibook-support.url = "github:petitstrawberry/minibook-support-nix";
    minibook-support.inputs.nixpkgs.follows = "nixpkgs";
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
    minibook-support,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    defaults = pkgs.callPackage ./defaults.nix inputs;

    specialArgs =
      (nixpkgs.lib.removeAttrs inputs ["self"])
      // {
        inherit inputs;
        inherit defaults;
      };

    haumeaInputs = prev:
      specialArgs
      // {
        pkgs = prev;
        inherit (nixpkgs) lib;
      };

    nixosModules = [
      {
        nixpkgs.overlays =
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
      }
      stylix.nixosModules.stylix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
          backupFileExtension = "bak";
          users.${defaults.username} = import ./home/${defaults.username}.nix;
          sharedModules = [
            vibeapps.homeManagerModules.default
            autofirma-nix.homeManagerModules.default
          ];
        };
      }
    ];

    vmConfiguration = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules =
        nixosModules
        ++ [
          ./hosts/vm
        ];
    };
  in {
    packages.${system} = {
      default = vmConfiguration.config.system.build.vm;
      nfoview = pkgs.callPackage ./pkgs/nfoview.nix {inherit pkgs;};
    };

    nixosConfigurations = {
      vm = vmConfiguration;

      live-usb = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/live-usb
          ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/desktop
          ];
      };

      minibookx = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            minibook-support.nixosModules.default
            nixos-hardware.nixosModules.chuwi-minibook-x
            ./hosts/minibookx
          ];
      };
    };

    homeConfigurations = {
      "${defaults.username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          vibeapps.homeManagerModules.default
          ./home/knoopx
        ];
      };
    };
  };
}
