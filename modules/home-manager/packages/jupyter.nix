{ pkgs, ... }:
{
  home.packages = with pkgs.python3Packages; [
    ipykernel
    ipython
    ipywidgets
    euporie
  ];
}
