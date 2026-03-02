{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    # llama-cpp
    # lmstudio
    # newsflash
    # picard
    # vial
    nfoview
    nicotine-plus
    prusa-slicer
    transmission_4-gtk
  ];
}
