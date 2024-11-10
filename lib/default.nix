{pkgs, ...}: {
  inherit
    (pkgs.callPackage ./mkSteamGameLauncher.nix {})
    btrfsSnapServiceName
    btrfsSnapService
    btrfsSnapTimer
    ;
  mkSteamGameLauncher = pkgs.callPackage ./mkSteamGameLauncher.nix {};
}
