{
  description = "kOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs";

    # julianjc84's niri fork with configurable touch gestures (for minibookx)
    niri-touch.url = "github:julianjc84/niri/feat/configurable-touch-gestures";
    niri-touch.inputs.nixpkgs.follows = "nixpkgs";

    astal-shell.url = "github:knoopx/astal-shell";
    astal-shell.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    betterfox.url = "github:yokoffing/BetterFox";
    betterfox.flake = false;

    usercontent-css.url = "github:knoopx/userContent.css";
    usercontent-css.inputs.nixpkgs.follows = "nixpkgs";

    vicinaehq.url = "github:vicinaehq/vicinae";
    vicinaehq.inputs.nixpkgs.follows = "nixpkgs";

    vicinae-extensions.url = "github:knoopx/vicinae-extensions";
    vicinae-extensions.flake = false;

    waveshare-genui.url = "github:knoopx/waveshare-genui";
    waveshare-genui.inputs.nixpkgs.follows = "nixpkgs";

    nixos-avf.url = "github:nix-community/nixos-avf";
    nixos-avf.inputs.nixpkgs.follows = "nixpkgs";

    ninfer.url = "github:knoopx/ninfer";
    ninfer.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs = inputs:
    let
      inherit (inputs) nixpkgs haumea home-manager niri stylix astal-shell firefox-addons vicinaehq;

      system = "x86_64-linux";

      specialArgs =
        (nixpkgs.lib.removeAttrs inputs [ "self" ])
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
          inputs.nix-cachyos-kernel.overlays.pinned
          inputs.astal-shell.overlays.default
          (self: super: { firefox-addons = inputs.firefox-addons.packages.${system}; })
          (self: super: { vicinaehq = inputs.vicinaehq; })
          (final: prev: { ninfer = inputs.ninfer.packages.${system}.ninfer; })
          (
            final: prev:
              haumea.lib.load {
                src = ./pkgs;
                loader = haumea.lib.loaders.scoped;
                inputs =
                  haumeaInputs final;
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

      mkNixosModules = hostPath:
        let
          hostOverlaysPath = hostPath + "/overlays.nix";
          hostOverlays =
            if builtins.pathExists hostOverlaysPath
            then [ (import hostOverlaysPath) ]
            else [ ];

          listNixModulesRecusive = import ./lib/listNixModulesRecusive.nix { inherit (nixpkgs) lib; };
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

      pkgsWithOverlays = import nixpkgs {
        inherit system;
        overlays = globalOverlays;
        config.allowUnfree = true;
      };

      # Target system for the installer (what gets installed to disk)
      installerTargetSystem = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          mkNixosModules ./hosts/minibookx
          ++ [
            inputs.disko.nixosModules.disko
            ./hosts/installer/system.nix
            # Virtio modules for VM testing (harmless on real hardware)
            { boot.initrd.availableKernelModules = [ "virtio_blk" "virtio_pci" ]; }
          ];
      };

      # Installer ISO configuration
      installerConfiguration = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/installer
          {
            _module.args.targetSystem = installerTargetSystem;
          }
        ];
      };
    in
    {
      packages.${system} =
        (haumea.lib.load {
          src = ./pkgs;
          loader = haumea.lib.loaders.scoped;
          inputs = haumeaInputs pkgsWithOverlays;
        })
        // {
          default = vmConfiguration.config.system.build.vm;
          installer-iso = installerConfiguration.config.system.build.isoImage;
          installer-vm-test = pkgsWithOverlays.writeShellScriptBin "installer-vm-test" ''
            set -e
            ISO=$(find ${installerConfiguration.config.system.build.isoImage}/iso/ -name "*.iso" | head -1)
            DISK="''${INSTALLER_VM_DISK:-''${XDG_RUNTIME_DIR:-/tmp}/installer-test-disk.qcow2}"

            echo "Creating test disk: $DISK (64GB sparse)"
            rm -f "$DISK"
            ${pkgsWithOverlays.qemu}/bin/qemu-img create -f qcow2 "$DISK" 64G

            echo "Starting VM with installer ISO..."
            echo "ISO: $ISO"
            exec ${pkgsWithOverlays.qemu}/bin/qemu-system-x86_64 \
              -enable-kvm \
              -m 8G \
              -smp 4 \
              -cpu host \
              -bios ${pkgsWithOverlays.OVMF.fd}/FV/OVMF.fd \
              -drive file="$DISK",format=qcow2,if=virtio \
              -cdrom "$ISO" \
              -boot d \
              -vga virtio \
              -display gtk,gl=on \
              -device virtio-vga-gl \
              -usb \
              -device usb-tablet \
              -nic user,model=virtio-net-pci
          '';
          android-image = inputs.self.nixosConfigurations.android.config.system.build.avfImage;
        };

      nixosConfigurations = {
        vm = vmConfiguration;

        installer = installerConfiguration;

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
          modules = mkNixosModules ./hosts/minibookx;
        };

        android = nixpkgs.lib.nixosSystem {
          modules = [
            inputs.nixos-avf.nixosModules.avf
            ./hosts/android
          ];
        };

        hi10max = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = mkNixosModules ./hosts/hi10max;
        };
      };
    };
}
