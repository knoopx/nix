{...}: {
  imports = [
    ./defaults.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "laptop";
}
