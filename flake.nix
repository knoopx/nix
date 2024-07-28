{
  description = "kOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";

    nix-colors.url = "github:misterio77/nix-colors";
    stylix.url = "github:danth/stylix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixd.url = "github:nix-community/nixd";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    darwin,
    stylix,
    nixpkgs,
    home-manager,
    nix-colors,
    ...
  } @ inputs: let
    inherit (self) outputs;

    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    # pkgs = import nixpkgs {
    #   inherit system;
    # };

    username = "knoopx";
    defaults = {
      keyMap = "us";
      timeZone = "Europe/Madrid";
      defaultLocale = "en_US.UTF-8";
      colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
      full-name = "Victor Martinez";
      # https://avatars.githubusercontent.com/u/100993
      avatar-image = ./home/${username}/assets/avatar.jpg;
      personal-email = "knoopx@gmail.com";
      work-email = "victor@jacoti.com";
      editor = "gum write";
      pubKeys = {
        url = "https://github.com/${username}.keys";
        sha256 = "sha256-385krE9Aoea23aQ3FJo2kpPtRrIOwxxXCCt43gHEo0Q=";
      };
      username = username;
      password = username;
      easyeffects = {
        irs = "Waves MaxxAudio ((Z-Edition)) AudioWizard 1.Music";
      };
      gnome = {
        extensions = with pkgs.gnomeExtensions; [
          hot-edge
          user-themes
          caffeine
          panel-corners
          tailscale-qs
          astra-monitor
          # alt-tab-scroll-workaround@lucasresck.github.io
          # TODO: package my own
          # system-stats@knoopx.net
        ];
      };
    };
    hm = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${defaults.username} = import ./home/${defaults.username}.nix;
      extraSpecialArgs = {inherit inputs outputs defaults stylix system;};
    };
  in {
    darwinConfigurations = {
      laptop = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs defaults stylix system;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          {home-manager = hm;}
          inputs.stylix.nixosModules.stylix
          ./nixos/hosts/laptop.nix
        ];
      };
    };
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs defaults stylix system;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          {home-manager = hm;}
          inputs.stylix.nixosModules.stylix
          ./nixos/hosts/desktop.nix
        ];
      };
      desktop-vm = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs defaults stylix system;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          {home-manager = hm;}
          inputs.stylix.nixosModules.stylix
          ./nixos/hosts/desktop-vm.nix
        ];
      };
    };
    homeConfigurations = {
      ${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        extraSpecialArgs = {inherit inputs outputs defaults stylix system;};
        modules = [
          ./home/knoopx.nix
        ];
      };
    };
  };
  # );
}
