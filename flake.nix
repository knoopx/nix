{
  description = "kOS";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs";

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
    home-manager,
    nix-colors,
    nixpkgs,
    self,
    stylix,
    umu-launcher,
    ...
  } @ inputs: let
    inherit (self) outputs;
    defaults = import ./defaults.nix {inherit pkgs nix-colors;};
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    specialArgs = {inherit inputs outputs defaults stylix;};

    myPkgsFrom = p:
      pkgs.callPackage ./pkgs/default.nix (specialArgs
        // {
          pkgs = p;
        });

    homeManagerConfig = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = specialArgs;
      backupFileExtension = "bak";
      users.${defaults.username} = import ./home/${defaults.username}.nix;
    };

    nixosModules = [
      {
        nixpkgs.overlays = [
          (self: super: umu-launcher.packages.x86_64-linux)
          (
            self: super: {firefox-addons = firefox-addons.packages.x86_64-linux;}
          )
          (
            self: super: (myPkgsFrom super)
          )
        ];
      }
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      {home-manager = homeManagerConfig;}
    ];
  in {
    packages.x86_64-linux = myPkgsFrom pkgs;

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
