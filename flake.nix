{
  description = "kOS";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-flatpak.url = "github:gmodena/nix-flatpak";

    # nixpkgs-update.url = "github:ryantm/nixpkgs-update";

    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # chaotic.inputs.nixpkgs.follows = "nixpkgs";
    # chaotic.inputs.home-manager.follows = "home-manager";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    # nix-gaming.url = "github:fufexan/nix-gaming";
    # nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    # jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    # jovian.inputs.nixpkgs.follows = "nixpkgs";

    umu-launcher.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    umu-launcher.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    # firefox-addons.inputs.flake-utils.follows = "flake-utils";
    # lix-module = {
    #   url = "git+https://git.lix.systems/lix-project/nixos-module?ref=stable";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # mdfried.url = "github:benjajaja/mdfried";
    # mdfried.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    stylix,
    nix-colors,
    nixpkgs,
    # nix-flatpak,
    home-manager,
    # lix-module,
    # nix-gaming,
    umu-launcher,
    # jovian,
    firefox-addons,
    # mdfried,
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
          # (self: super: {mdfried = mdfried.packages.x86_64-linux.default;})
          (self: super: umu-launcher.packages.x86_64-linux)
          # (self: super: nix-gaming.packages.x86_64-linux)
          (
            self: super: {firefox-addons = firefox-addons.packages.x86_64-linux;}
          )
          (
            self: super: (myPkgsFrom super)
          )
        ];
      }
      # chaotic.nixosModules.default
      # lix-module.nixosModules.default
      inputs.stylix.nixosModules.stylix
      # nix-flatpak.nixosModules.nix-flatpak
      # jovian.nixosModules.jovian

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
        modules =
          # nixosModules
          [
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                backupFileExtension = "bak";
                users.jegos = import ./home/jegos.nix;
              };
            }
            # {
            #   nixpkgs.overlays = [
            #     (self: super: nix-gaming.packages.x86_64-linux)
            #   ];
            # }
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
