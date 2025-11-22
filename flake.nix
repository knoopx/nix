{
  description = "kOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs?rev=b26b855658cae69587124c3fb65f805e4b88b540"; # works
    # nixpkgs.url = "github:nixos/nixpkgs?rev=a2e92afc50a795dfe756e9d3a9e0bdaa82a645ff"; # broken

    nix-userstyles.url = "github:knoopx/nix-userstyles";
    nix-userstyles.inputs.nixpkgs.follows = "nixpkgs";
    nix-userstyles.inputs.nix-colors.follows = "nix-colors";

    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.firefox-gnome-theme.follows = "firefox-gnome-theme";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    astal-shell.url = "github:knoopx/astal-shell";
    astal-shell.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    firefox-gnome-theme.url = "github:rafaelmardojai/firefox-gnome-theme";
    firefox-gnome-theme.flake = false;

    betterfox.url = "github:yokoffing/BetterFox";
    betterfox.flake = false;

    adwaita-colors.url = "github:dpejoh/Adwaita-colors";
    adwaita-colors.flake = false;

    neuwaita.url = "github:RusticBard/Neuwaita";
    neuwaita.flake = false;

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    astal-shell,
    firefox-addons,
    haumea,
    home-manager,
    niri,
    nix-vscode-extensions,
    nixpkgs,
    stylix,
    nix-userstyles,
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
        astal-shell.overlays.default
        nix-vscode-extensions.overlays.default
        niri.overlays.niri
        (self: super: {firefox-addons = firefox-addons.packages.${system};})
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

      listNixModulesRecusive = import ./lib/listNixModulesRecusive.nix {inherit (nixpkgs) lib;};
    in
      (listNixModulesRecusive ./modules/nixos/defaults)
      ++ [
        {
          nixpkgs.overlays = globalOverlays ++ hostOverlays;
        }
        stylix.nixosModules.stylix
        niri.nixosModules.niri
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            backupFileExtension = "bak";
            sharedModules = [
              astal-shell.homeManagerModules.default
            ];
          };
        }
        hostPath
      ];

    vmConfiguration = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = mkNixosModules ./hosts/vm;
    };

    pkgsWithOverlays = import nixpkgs {
      inherit system;
      overlays = globalOverlays;
    };
  in {
    packages.${system} = {
      default = vmConfiguration.config.system.build.vm;
      neuwaita-icon-theme = pkgsWithOverlays.neuwaita-icon-theme;
      nfoview = pkgsWithOverlays.nfoview;
      llama-swap = pkgsWithOverlays.llama-swap;
      geary = pkgsWithOverlays.geary;
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

      laptop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = mkNixosModules ./hosts/laptop;
      };

      minibookx = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = mkNixosModules ./hosts/minibookx;
      };
    };
  };
}
