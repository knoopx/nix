{pkgs, ...}: {
  home.packages = with pkgs; [
    cargo
    rustc
    rustfmt
  ];
}
