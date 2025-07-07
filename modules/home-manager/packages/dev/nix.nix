{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    nix-search-tv
    nixd
  ];
}
