{pkgs, ...}: {
  home.packages = with pkgs; [
    # android-tools
    # asciinema
    # atuin
    # axel
    # bandwhich
    # bash
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
    ast-grep
    brotab
    caligula
    dconf
    duckdb
    exiftool
    fclones
    ffmpeg
    gcalcli
    gum
    imagemagick
    inotify-tools
    jq
    llama-cpp
    llm
    mpv
    navi
    nh
    nixos-changelog
    ollamark
    rclone
    rsync
    say
    strip-python-comments
    wl-clipboard
    python313Packages.markitdown
  ];
}
