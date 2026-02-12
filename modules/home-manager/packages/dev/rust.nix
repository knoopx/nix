{pkgs, ...}: {
  home.packages = with pkgs; [
    cargo
    rustc
    rustfmt
    rust-analyzer
  ];
}
