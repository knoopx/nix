{
  pkgs,
  inputs,
  ...
}: {
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
    imagemagick
    inetutils
    inotify-tools
    jc
    jjui
    jq
    just
    lshw
    lsof
    nh
    nvd
    ox
    p7zip
    pciutils
    pcre
    pi
    pi-sandbox
    rclone
    reader
    ripgrep
    rsync
    ruff
    sem
    weave
    mcat
    inspect
    shfmt
    skate
    socat
    sox
    sqlite
    tmux
    typescript-language-server
    jq-lsp
    yaml-language-server
    up # repl
    usbutils
    util-linux
    wacli

    wirelesstools
    wl-clipboard
    xxd
    yt-dlp
    marksman
    mdtt
    tree
    rust-analyzer
    rustfmt
    gogcli
    fswatch
    nb
    w3m
    tts
    zk
    http-nu
    typescript-go
    emacs
    plocate
    findutils
    websocat
    wshowkeys
    android-tools
    poppler-utils
    skopeo
    inputs.waveshare-genui.packages.${pkgs.stdenv.hostPlatform.system}.default
    pick-project
    pick-document
    jj-hunk
  ];
}
