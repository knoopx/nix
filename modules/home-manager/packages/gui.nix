{
  pkgs,
  inputs,
  ...
}: let
  camper = inputs.camper.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  home.packages = with pkgs; [
    (callPackage ../../../pkgs/gram.nix {})
    # (callPackage ../../../pkgs/romie.nix {})
    # apostrophe
    # ascii-draw
    # authenticator
    # balatro
    # cartridges
    # d-spy
    # decibels
    # delineate
    # dissent
    # eloquent
    # emblem
    # errands
    # exhibit # preview 3d models
    # fclones-gui
    # foliate
    # gapless
    # gearlever
    # ghidra
    # gnome-feeds
    # gnome-mahjongg
    # gnome-sudoku
    # google-chrome
    # impression
    # mission-center
    # newelle
    # obsidian
    # parlatype
    # pipeline
    # planify
    # pods
    # recordbox
    # rnote
    # showtime
    # sly
    # snapshot
    # varia
    # wike
    # wildcard
    amberol
    baobab
    btrfs-assistant
    commit
    czkawka
    dconf-editor
    drawing
    eog
    evince
    file-roller
    geary
    gnome-calendar
    gnome-disk-utility
    gnome-secrets
    gnome-text-editor
    gnome-weather
    camper
    loupe
    nautilus
    onlyoffice-desktopeditors
    pinta
    plexamp
    seahorse
    sushi
  ];
}
