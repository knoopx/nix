{pkgs, ...}: {
  # brothers-a-tale-of-two-sons-remake = pkgs.callPackage ./games/brothers-a-tale-of-two-sons-remake.nix {};
  # celeste = pkgs.callPackage ./games/celeste.nix {};
  # driver-san-francisco = pkgs.callPackage ./games/driver-san-francisco.nix {};
  # liftoff = pkgs.callPackage ./games/liftoff.nix {};
  # supermeatboy = pkgs.callPackage ./games/supermeatboy.nix {};
  # uncrashed = pkgs.callPackage ./games/uncrashed.nix {};
  # worldofgoo = pkgs.callPackage ./games/worldofgoo.nix {};

  citron-emu = pkgs.callPackage ./emulation/citron-emu.nix {};
  datutil = pkgs.callPackage ./emulation/datutil.nix {};
  es-de = pkgs.callPackage ./emulation/es-de.nix {};
  hydra-launcher = pkgs.callPackage ./emulation/hydra-launcher.nix {};
  ryujinx = pkgs.callPackage ./emulation/ryujinx {};
  shadps4 = pkgs.callPackage ./emulation/shadps4.nix {};
  skyscraper = pkgs.callPackage ./emulation/skyscraper.nix {};
  sudachi = pkgs.callPackage ./emulation/sudachi {};
  wiiudownloader = pkgs.callPackage ./emulation/wiiudownloader.nix {};

  lora-inspector = pkgs.callPackage ./cli/lora-inspector.nix {};

  aide = pkgs.callPackage ./apps/aide.nix {};
  nfoview = pkgs.callPackage ./apps/nfoview.nix {};

  mkUserStyles = pkgs.callPackage ./theming/mkUserStyles.nix {};
  mkStylixFirefoxGnomeTheme = pkgs.callPackage ./theming/mkStylixFirefoxGnomeTheme.nix {};
  mkStylixMemosPkg = pkgs.callPackage ./theming/mkStylixMemosPkg.nix {};

  factorio =
    pkgs.factorio.overrideAttrs
    {
      pname = "factorio";
      version = "2.0.14";
      src = fetchTarball {
        url = "file:///mnt/storage/Games/factorio_linux_2.0.14.tar.xz";
        sha256 = "sha256:0jy2qxayis4gw6fsgr15nbm77fqxrrkvmm0lfw83lhnz9qc05lza";
      };
    };

  factorio-space-age =
    pkgs.factorio-space-age.overrideAttrs
    {
      version = "2.0.14";
      src = fetchTarball {
        url = "file:///mnt/storage/Games/factorio-space-age_linux_2.0.14.tar.xz";
        sha256 = "sha256:047h66lp6bg92njsss0l5a9pipd9v578cxqrdf6aql54z2wsp9hq";
      };
    };

  code-cursor =
    pkgs
    .code-cursor
    .overrideAttrs
    (oldAttr: {
      installPhase =
        oldAttr.installPhase
        + ''
          rm $out/bin/cursor
          mv $out/bin/.cursor-wrapped $out/bin/cursor
        '';
    });
}
