{pkgs, ...}: let
  steam = pkgs.callPackage ../../lib/steam.nix {};
in
  steam.steamApp rec {
    pname = "uncrashed";
    gameId = 1682970;
    sha256 = "sha256-sDOHJWOm6mqJk9h1AYiJV7QvI9eehpfPcTCAVsi0LsY=";

    wrapper = steam.umuDwarfWrapper {
      inherit pname gameId;
      entrypoint = "Uncrashed.exe";
      dwarf = "/mnt/storage/Games/uncrashed-fpv-drone-simulator_win64.dwarf";
    };
  }
