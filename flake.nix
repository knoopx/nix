{
  description = "kOS";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "nixpkgs/staging-next";
    nixpkgs.url = "github:NixOS/nixpkgs";
    # nixpkgs.url = "github:knoopx/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # nixpkgs-update.url = "github:ryantm/nixpkgs-update";

    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # chaotic.inputs.nixpkgs.follows = "nixpkgs";
    # chaotic.inputs.home-manager.follows = "home-manager";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    # lix-module = {
    #   url = "git+https://git.lix.systems/lix-project/nixos-module?ref=stable";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    stylix,
    nix-colors,
    nixpkgs,
    nix-flatpak,
    home-manager,
    # lix-module,
    nix-gaming,
    ...
  } @ inputs: let
    inherit (self) outputs;
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    defaults = import ./defaults.nix {inherit pkgs nix-colors;};

    mylib = pkgs.callPackage ./lib {};
    specialArgs = {inherit inputs outputs defaults stylix;} // mylib;

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
          (self: super: nix-gaming.packages.x86_64-linux)
          (
            self: super: (pkgs.callPackage ./pkgs/default.nix {
              pkgs = super;
            })
          )
        ];
      }
      {home-manager = homeManagerConfig;}
      # chaotic.nixosModules.default
      # lix-module.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
      nix-flatpak.nixosModules.nix-flatpak
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

      desktop-vm = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            ./hosts/desktop-vm
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
