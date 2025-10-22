{
  description = "kOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    nix-userstyles.url = "github:knoopx/nix-userstyles";
    nix-userstyles.inputs.nixpkgs.follows = "nixpkgs";
    nix-userstyles.inputs.nix-colors.follows = "nix-colors";

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae.inputs.nixpkgs.follows = "nixpkgs";

    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:YaLTeR/niri";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    xwayland-satellite.url = "github:Supreeeme/xwayland-satellite";
    xwayland-satellite.inputs.nixpkgs.follows = "nixpkgs";

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

    autofirma-nix.url = "github:nix-community/autofirma-nix";
    autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";
    autofirma-nix.inputs.home-manager.follows = "home-manager";

    nix-chuwi-minibook-x.url = "github:knoopx/nix-chuwi-minibook-x";
    nix-chuwi-minibook-x.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    astal-shell,
    autofirma-nix,
    firefox-addons,
    haumea,
    home-manager,
    niri,
    nix-vscode-extensions,
    nix-chuwi-minibook-x,
    nixpkgs,
    stylix,
    xwayland-satellite,
    nix-userstyles,
    vicinae,
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
        (self: super: {niri = niri.packages.${system}.default;})
        (self: super: {xwayland-satellite = xwayland-satellite.packages.${system}.default;})
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
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            backupFileExtension = "bak";
            sharedModules = [
              vicinae.homeManagerModules.default
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

      minibookx = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          (mkNixosModules ./hosts/minibookx)
          ++ [
            nix-chuwi-minibook-x.nixosModules.default
          ];
      };
    };
  };
}
