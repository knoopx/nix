{pkgs, ...}: let
  gtk = with pkgs; [
    # lapce
    # qmk
    # zed-editor
    amberol
    apostrophe
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
    # f3d
    fclones-gui
    file-roller
    folio
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
    popsicle
    prusa-slicer
    seahorse
    showtime
    snapshot
    sushi
    transmission_4-gtk
    vial
    dataset-viewer
    notes
    chat
    music
    scratchpad
    reminder
    nix-packages
    webkit-shell
    foliate
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
    # jq
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
    dconf
    fclones
    ffmpeg
    inotify-tools
    mpv
    nh
    ollamark
    rclone
    rsync
    tgpt
    md2html
    (python312.withPackages
      (p: [
        p.pygobject3
        p.openai
        p.lark
        p.pyparsing
        p.pygobject-stubs
      ]))
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
    uv
  ];
in {
  home = {
    packages = dev ++ gtk ++ cli;
  };
}
