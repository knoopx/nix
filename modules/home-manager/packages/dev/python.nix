{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    black
    isort
    pyright
    python313
  ];
}
