{pkgs, ...}: let
  gtk-apps = with pkgs; [
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
    # android-tools
    # aria2
    # asciinema
    # ast-grep
    # atuin
    # axel
    # bandwhich
    # bash
    # bash-language-server
    # bison
    # btrfs-snap
    # ccache
    # clang-tools
    # cmake
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
    # gcc
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
    # libsecret
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
    # pkg-config
    # psmisc
    # rage
    # ranger
    # readline
    # sd
    # shfmt
    # skate
    # skim
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
    alejandra
    bun
    dconf
    fclones
    ffmpeg
    mpv
    nh
    nix-search-tv
    nixd
    nodejs_latest
    ollamark
    rclone
    rsync
    ruby
    ruby-lsp
    rufo
    uv
  ];
in {
  home = {
    packages = gtk-apps ++ cli-apps;
  };
}
