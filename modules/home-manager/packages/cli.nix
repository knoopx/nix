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
    # harlequin # db client, broken, installed as uv tool
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
    # posting # broken, installed as uv tool
    # python313Packages.markitdown
    # rage
    # ranger
    # readline
    # rich-cli
    # sd
    # shfmt
    # skate
    # smartmontools
    # smassh # monkeytype clone
    # speedtest-cli
    # sqlite
    # sysz
    # tab
    # taskwarrior3
    # tree
    # usbutils
    # util-linux
    # vllm
    # w3m
    # walk
    # xq-xml
    # xz
    # yq
    # yq-go
    # zlib
    # zstd
    aria2
    ast-grep
    binsider
    brotab
    caligula
    circumflex # hackernews client
    csvkit
    csvlens
    dasel
    dconf
    drum-practice
    duckdb
    exiftool
    fclones
    ffmpeg
    fx # jq alternative
    gcalcli
    gum
    imagemagick
    inotify-tools
    jq
    llama-cpp
    lsof
    mpv
    navi
    nh
    nixos-changelog
    ox
    p7zip
    rclone
    repl
    rsync
    ruff
    say
    shfmt
    strip-python-comments
    todos
    up # repl
    visidata
    wf-recorder
    wl-clipboard
    yt-dlp
  ];
}
