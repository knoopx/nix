{pkgs, ...}: {
  aide = pkgs.callPackage ./apps/aide.nix {};
  celeste = pkgs.callPackage ./games/celeste.nix {};
  datutil = pkgs.callPackage ./emulation/datutil.nix {};
  driver-san-francisco = pkgs.callPackage ./games/driver-san-francisco.nix {};
  es-de = pkgs.callPackage ./emulation/es-de.nix {};
  liftoff = pkgs.callPackage ./games/liftoff.nix {};
  nfoview = pkgs.callPackage ./apps/nfoview.nix {};
  ryujinx = pkgs.callPackage ./emulation/ryujinx {};
  shadps4 = pkgs.callPackage ./emulation/shadps4.nix {};
  sudachi = pkgs.callPackage ./emulation/sudachi {};
  citron-emu = pkgs.callPackage ./emulation/citron-emu.nix {};
  supermeatboy = pkgs.callPackage ./games/supermeatboy.nix {};
  uncrashed = pkgs.callPackage ./games/uncrashed.nix {};
  zen-browser = pkgs.callPackage ./apps/zen-browser.nix {};
  worldofgoo = pkgs.callPackage ./games/worldofgoo.nix {};
  brothers-a-tale-of-two-sons-remake = pkgs.callPackage ./games/brothers-a-tale-of-two-sons-remake.nix {};
  skyscraper = pkgs.callPackage ./emulation/skyscraper.nix {};
  wiiudownloader = pkgs.callPackage ./emulation/wiiudownloader.nix {};
  hydra-launcher = pkgs.callPackage ./emulation/hydra-launcher.nix {};

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
