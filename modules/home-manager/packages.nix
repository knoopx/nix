{pkgs, ...}: let
  gtk-apps = with pkgs; [
    alpaca
    amberol
    authenticator
    baobab
    commit
    cromite
    czkawka
    dconf-editor
    decibels
    drawing
    eog
    evince
    f3d
    fclones-gui
    file-roller
    gitg
    gnome-disk-utility
    gnome-calendar
    gnome-text-editor
    loupe
    nautilus
    nfoview
    nicotine-plus
    onlyoffice-bin
    pinta
    plexamp
    popsicle
    prusa-slicer
    qmk
    seahorse
    showtime
    snapshot
    sushi
    transmission_4-gtk
    vial
  ];

  cli-apps = with pkgs; [
    dconf
    libnotify
    alejandra
    android-tools
    aria2
    ast-grep
    bash-language-server
    bun
    duckdb
    duperemove
    fclones
    fdupes
    libsecret
    mpv
    nh
    nixd
    nodejs_latest
    ollamark
    rclone
    ruby
    ruby-lsp
    rufo
    shfmt
    uv
  ];
in {
  home = {
    packages = gtk-apps ++ cli-apps;
  };
}
