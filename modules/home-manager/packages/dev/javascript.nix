{pkgs, ...}: {
  home.packages = with pkgs; [
    bun
    nodejs_latest
  ];
}
