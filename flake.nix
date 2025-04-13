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

      desktop-vm = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/desktop-vm
          ];
      };

      jegos-vm = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              backupFileExtension = "bak";
              users.jegos = import ./home/jegos.nix;
            };
          }
          ./hosts/jegos-vm.nix
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
        ];
      };

      # https://www.reddit.com/r/NixOS/comments/y1xo2u/how_to_create_an_iso_with_my_config_files/
      live = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          inputs.stylix.nixosModules.stylix
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
          ./hosts/live
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
