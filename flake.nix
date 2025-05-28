{
  description = "kOS";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs";

    vibeapps.url = "github:knoopx/vibeapps";
    vibeapps.inputs.nixpkgs.follows = "nixpkgs";

    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    globset = {
      url = "github:pdtpartners/globset";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    ags.url = "github:aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";

    astal-shell.url = "github:knoopx/ags";

    niri-flake.url = "github:sodiboo/niri-flake";
    niri-flake.inputs.nixpkgs.follows = "nixpkgs";
    niri-flake.inputs.niri-stable.url = "github:YaLTeR/niri/v25.05.1";

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
  };

  outputs = {
    firefox-addons,
    haumea,
    home-manager,
    nixpkgs,
    stylix,
    niri-flake,
    vibeapps,
    astal-shell,
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
      niri-flake.nixosModules.niri
      {
        nixpkgs.overlays =
          [
            niri-flake.overlays.niri
            astal-shell.overlays.default
            (self: super: vibeapps.packages.${system})
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
          ];
        };
      }
    ];
  in {
    nixosConfigurations = {
      vm = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/vm
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

      macbook = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/macbook
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
