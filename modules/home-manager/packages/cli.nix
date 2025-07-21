{pkgs, ...}: {
  home.packages = with pkgs; [
    _7zz
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
    # goose-cli
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
    # vllm
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
    p7zip
    python313Packages.markitdown
    rclone
    rsync
    say
    shfmt
    strip-python-comments
    wl-clipboard
    yt-dlp
    drum-practice
  ];
}
