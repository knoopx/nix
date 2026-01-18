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
    # dwarfs
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
    # umu-launcher
    # visidata
    # vllm
    # w3m
    # walk
    # wlrctl
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
    bubblewrap
    caligula
    circumflex # hackernews client
    clang-tools
    codemapper
    csvkit
    csvlens
    dasel
    dconf
    distrobox
    dmidecode
    duckdb
    exiftool
    fclones
    ffmpeg
    fx # jq alternative
    gcalcli
    gh
    google-authenticator-qr-decode
    guitar
    gum
    imagemagick
    inetutils
    inotify-tools
    jc
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
    pi
    python313Packages.markitdown
    rclone
    reader
    ripgrep
    rsync
    ruff
    shfmt
    skate
    socat
    sox
    tmux
    up # repl
    usbutils
    util-linux
    wf-recorder
    wirelesstools
    wl-clipboard
    worktrunk
    xxd
    yt-dlp
  ];
}
