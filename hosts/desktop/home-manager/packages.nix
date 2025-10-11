{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    # llama-cpp
    # lmstudio
    newsflash
    nfoview
    nicotine-plus
    picard
    prusa-slicer
    transmission_4-gtk
    vial
    ollama-cuda
  ];
}
