{pkgs, ...}: {
  programs.chromium.enable = false;
  programs.chromium.package = pkgs.cromite;
}
