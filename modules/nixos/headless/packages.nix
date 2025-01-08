{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bash
    binutils
    bison
    curl
    debugedit
    diffutils
    elfutils
    file
    gcc
    gettext
    glib
    glibc
    gnugrep
    gnumake
    gnused
    gnutar
    gnutls
    gzip
    less
    libarchive
    libelf
    libffi
    libgcc
    libgccjit
    libgcrypt
    libusb1
    libuv
    libxml2
    logrotate
    lz4
    lzo
    m4
    openssl
    patch
    pcre
    pcre2
    perl
    # python3
    readline
    sqlite
    tzdata
    util-linux
    which
    xz
    zlib
    zstd

    # neomutt
    ffmpeg
    asciinema
    bat
    ccache
    clang-tools
    cmake
    dasel
    dmidecode
    dnsutils
    efibootmgr
    eza
    fastfetch
    fd
    figurine
    file
    fzf
    git
    glow
    gnumake
    gum
    hdparm
    htop
    iperf
    jq
    libxml2
    lm_sensors
    lshw
    lsof
    micro
    miller
    ntfs3g
    openssl
    p7zip
    lrzip
    patchelf
    pciutils
    pkg-config
    psmisc
    ripgrep
    rsync
    sd
    skate
    smartmontools
    sysz
    tab
    trash-cli
    tree
    unrar
    unzip
    usbutils
    w3m
    wget
    whois
    yazi
    yq
    zip
    git-lfs
    btop
    ranger
    speedtest-cli
    axel
    atuin
    btrfs-snap
  ];
}
