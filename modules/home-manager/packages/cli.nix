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
    # black
    # btrfs-snap
    # ccache
    # clang-tools
    # dasel
    # debugedit
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
    # isort
    # just
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
    # lz4
    # lzo
    # m4
    # miller
    # nap
    # nethogs
    # patchelf
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
    bluez
    bluez-tools
    brotab
    caligula
    circumflex # hackernews client
    clang-tools
    csvkit
    csvlens
    dasel
    dconf
    dmidecode
    duckdb
    exiftool
    fclones
    ffmpeg
    fx # jq alternative
    gcalcli
    gum
    imagemagick
    inetutils
    inotify-tools
    jq
    lshw
    lsof
    mpv
    nh
    nvd
    opencode
    ox
    p7zip
    pciutils
    pcre
    rclone
    rsync
    ruff
    shfmt
    up # repl
    usbutils
    util-linux
    visidata
    wf-recorder
    wirelesstools
    wl-clipboard
    xxd
    yt-dlp
    google-authenticator-qr-decode
    nushell
  ];
}
