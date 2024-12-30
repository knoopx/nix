{pkgs, ...}: {
  lora-inspector = pkgs.callPackage ./cli/lora-inspector.nix {};
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
  worldofgoo = pkgs.callPackage ./games/worldofgoo.nix {};
  brothers-a-tale-of-two-sons-remake = pkgs.callPackage ./games/brothers-a-tale-of-two-sons-remake.nix {};
  skyscraper = pkgs.callPackage ./emulation/skyscraper.nix {};
  wiiudownloader = pkgs.callPackage ./emulation/wiiudownloader.nix {};
  hydra-launcher = pkgs.callPackage ./emulation/hydra-launcher.nix {};
  catppuccin-userstyles = pkgs.callPackage ./theming/catppuccin-userstyles.nix {};

  mkStylixFirefoxGnomeTheme = pkgs.callPackage ./theming/mkStylixFirefoxGnomeTheme.nix {};

  launchbox-metadata = pkgs.stdenv.mkDerivation {
    name = "launchbox-metadata";

    installPhase = ''
      mkdir -p $out/share/launchbox-metadata
      cp $src/* $out/share/launchbox-metadata
    '';

    src = fetchTarball {
      url = "http://gamesdb.launchbox-app.com/Metadata.zip";
      sha256 = "sha256:1m6xy2kyala5c586f2sksn2ng9gs9mad0njqgd0ssmasnrabpdzr";
    };
  };

  libretro-metadata = pkgs.stdenv.mkDerivation {
    name = "libretro-metadata";

    installPhase = ''
      mkdir -p $out/share/libretro-metadata
      cp -r $src/{cht,dat,metadat,rdb} $out/share/libretro-metadata
    '';

    src = pkgs.fetchFromGitHub {
      owner = "libretro";
      repo = "libretro-database";
      rev = "49acc074cc09d1b9a1bfb67e5c490b10c443ff89";
      hash = "sha256-oZFuwBTOffmBTYKn9LSfIulR5gjOZ1gJIkJcgRH2ezg=";
    };
  };

  libretro-db_tool = pkgs.stdenv.mkDerivation rec {
    name = "libretro-db_tool";
    version = "1.19.1";

    src = pkgs.fetchFromGitHub {
      owner = "libretro";
      repo = "RetroArch";
      rev = "v${version}";
      hash = "sha256-NVe5dhH3w7RL1C7Z736L5fdi/+aO+Ah9Dpa4u4kn0JY=";
    };

    # sourceRoot = "${src.name}/libretro-db";
    preConfigure = ''
      cd libretro-db
    '';

    installPhase = ''
      install -D libretrodb_tool $out/bin/libretrodb_tool
    '';
  };

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
