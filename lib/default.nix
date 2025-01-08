{
  pkgs,
  inputs,
  ...
}: rec {
  inherit
    (pkgs.callPackage ./btfsSnap.nix {})
    btrfsSnapServiceName
    btrfsSnapService
    btrfsSnapTimer
    ;
  mkSteamGameLauncher = pkgs.callPackage ./mkSteamGameLauncher.nix {};
  hexToDec = inputs.nix-colors.lib.conversions.hexToDec;
  hexToHSL = pkgs.callPackage ./hexToHSL.nix {inherit hexToDec;};
}
