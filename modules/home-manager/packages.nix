{pkgs, ...}: let
  gtk = with pkgs; [
    # f3d
    # lapce
    # qmk
    # zed-editor
    amberol
    apostrophe
    authenticator
    baobab
    commit
    czkawka
    dataset-viewer
    dconf-editor
    decibels
    drawing
    eog
    evince
    fclones-gui
    file-roller
    foliate
    gitg
    gnome-calendar
    gnome-disk-utility
    gnome-text-editor
    gnome-weather
    loupe
    mission-center
    nautilus
    nfoview
    nicotine-plus
    onlyoffice-bin
    picard
    pinta
    prusa-slicer
    rnote
    seahorse
    showtime
    snapshot
    sushi
    transmission_4-gtk
    vial
  ];

  cli = with pkgs; [
    # android-tools
    # asciinema
    # atuin
    # axel
    # bandwhich
    # bash
    # bash-language-server
    # bison
    # btrfs-snap
    # ccache
    # clang-tools
    # dasel
    # debugedit
    # dmidecode
    # duckdb
    # duperemove
    # efibootmgr
    # elfutils
    # fastfetch
    # fdupes
    # figurine
    # gettext
    # glib
    # glibc
    # glibc.dev
    # glow
    # gum
    # hdparm
    # iftop
    # iperf
    # less
    # libarchive
    # libelf
    # libffi
    # libgcc
    # libgccjit
    # libgcrypt
    # libnotify
    # libusb1
    # libuv
    # libxml2
    # lm_sensors
    # logrotate
    # lshw
    # lsof
    # lz4
    # lzo
    # m4
    # miller
    # nap
    # nethogs
    # patchelf
    # pciutils
    # pcre
    # pcre2
    # perl
    # rage
    # ranger
    # readline
    # sd
    # shfmt
    # skate
    # smartmontools
    # speedtest-cli
    # sqlite
    # sysz
    # tab
    # tree
    # usbutils
    # util-linux
    # w3m
    # walk
    # xz
    # yq
    # zlib
    # zstd
    aria2
    brotab
    caligula
    dconf
    exiftool
    fclones
    ffmpeg
    imagemagick
    inotify-tools
    jq
    mpv
    nh
    nixos-changelog
    ollamark
    rclone
    rsync
    tgpt
  ];

  dev = with pkgs; [
    alejandra
    ast-grep
    bun
    cmake
    gcc
    gnumake
    nix-search-tv
    nixd
    nodejs_latest
    pkg-config
    ruby
    ruby-lsp
    rufo
    strip-python-comments
    uv
  ];
in {
  home = {
    packages = dev ++ gtk ++ cli;
  };
}
