{
  description = "kOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs";

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

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    umu-launcher.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    umu-launcher.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    firefox-addons,
    haumea,
    home-manager,
    nixpkgs,
    stylix,
    umu-launcher,
    ...
  } @ inputs: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
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
            (self: super: umu-launcher.packages.x86_64-linux)
            (
              self: super: {firefox-addons = firefox-addons.packages.x86_64-linux;}
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
        };
      }
    ];
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/desktop
          ];
      };
    };

    homeConfigurations = {
      "${defaults.username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          ./home/knoopx
        ];
      };
    };
  };
}
