{
  description = "kOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

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

    vicinaehq.url = "github:vicinaehq/vicinae";
    vicinaehq.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    vicinae-extensions.url = "github:knoopx/vicinae-extensions";
    vicinae-extensions.flake = false;
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs haumea home-manager niri nix-vscode-extensions stylix astal-shell firefox-addons vicinaehq;

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
        inputs.astal-shell.overlays.default
        inputs.nix-vscode-extensions.overlays.default
        (self: super: {firefox-addons = inputs.firefox-addons.packages.${system};})
        (self: super: {vicinaehq = inputs.vicinaehq;})
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
        inputs.niri.nixosModules.niri
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            backupFileExtension = "bak";
            sharedModules = [
              inputs.astal-shell.homeManagerModules.default
            ];
          };
        }
        hostPath
      ];

    vmConfiguration = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = mkNixosModules ./hosts/vm;
    };

    steamdeckVmConfiguration = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules =
        mkNixosModules ./hosts/steamdeck
        ++ [
          "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
          "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
          ({lib, ...}: {
            virtualisation.memorySize = 4096;
            virtualisation.cores = 4;
            virtualisation.resolution.x = 1280;
            virtualisation.resolution.y = 800;
            virtualisation.qemu.options = [
              "-vga virtio"
              "-device virtio-vga-gl"
              "-display gtk,gl=on"
              "-device usb-tablet"
              "-device usb-kbd"
            ];
            services.spice-vdagentd.enable = true;
            boot.kernelModules = ["uinput" "evdev"];
            boot.initrd.kernelModules = ["virtio_gpu"];
            virtualisation.forwardPorts = [
              {
                from = "host";
                host.port = 2223;
                guest.port = 22;
              }
            ];
            fileSystems."/" = {
              device = "/dev/disk/by-label/nixos";
              fsType = "xfs";
              autoResize = true;
            };
            fileSystems."/boot" = {
              device = "/dev/vda1";
              fsType = "vfat";
            };
            boot.loader.systemd-boot.enable = lib.mkForce false;
            boot.loader.grub.device = "/dev/vda";
            services.btrfs.autoScrub.enable = false;
            services.btrfs.autoScrub.fileSystems = [];
          })
        ];
    };

    pkgsWithOverlays = import nixpkgs {
      inherit system;
      overlays = globalOverlays;
      config.allowUnfree = true;
    };
  in {
    packages.${system} = {
      default = vmConfiguration.config.system.build.vm;
      steamdeck-vm = steamdeckVmConfiguration.config.system.build.vm;
      neuwaita-icon-theme = pkgsWithOverlays.neuwaita-icon-theme;
      nfoview = pkgsWithOverlays.nfoview;
      geary = pkgsWithOverlays.geary;
      codemapper = pkgsWithOverlays.codemapper;
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

      steamdeck = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = mkNixosModules ./hosts/steamdeck;
      };

      steamdeck-vm = steamdeckVmConfiguration;
    };
  };
}
