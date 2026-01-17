{pkgs, ...}: {
  home.packages = with pkgs; [
    nushell
    nufmt
  ];
}
