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
    bat
    binsider
    biome
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
    glow
    google-authenticator-qr-decode
    gum
    himalaya
    imagemagick
    inetutils
    inotify-tools
    jc
    jjui
    jq
    just
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
    rclone
    reader
    ripgrep
    rsync
    ruff
    shfmt
    skate
    socat
    sox
    sqlite
    tmux
    typescript-language-server
    up # repl
    usbutils
    util-linux
    wacli
    wf-recorder
    wirelesstools
    wl-clipboard
    xxd
    yt-dlp
    marksman
    tree
  ];
}
