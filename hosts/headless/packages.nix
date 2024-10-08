{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pkgsx86_64_v4.bash
    pkgsx86_64_v4.binutils
    pkgsx86_64_v4.bison
    pkgsx86_64_v4.curl
    pkgsx86_64_v4.debugedit
    pkgsx86_64_v4.diffutils
    pkgsx86_64_v4.elfutils
    pkgsx86_64_v4.file
    pkgsx86_64_v4.gcc
    pkgsx86_64_v4.gettext
    pkgsx86_64_v4.glib
    pkgsx86_64_v4.glibc
    pkgsx86_64_v4.gnugrep
    pkgsx86_64_v4.gnumake
    pkgsx86_64_v4.gnused
    pkgsx86_64_v4.gnutar
    pkgsx86_64_v4.gnutls
    pkgsx86_64_v4.gzip
    pkgsx86_64_v4.less
    pkgsx86_64_v4.libarchive
    pkgsx86_64_v4.libelf
    pkgsx86_64_v4.libffi
    pkgsx86_64_v4.libgcc
    pkgsx86_64_v4.libgccjit
    pkgsx86_64_v4.libgcrypt
    pkgsx86_64_v4.libusb
    pkgsx86_64_v4.libuv
    pkgsx86_64_v4.libxml2
    pkgsx86_64_v4.logrotate
    pkgsx86_64_v4.lz4
    pkgsx86_64_v4.lzo
    pkgsx86_64_v4.m4
    pkgsx86_64_v4.openssl
    pkgsx86_64_v4.patch
    pkgsx86_64_v4.pcre
    pkgsx86_64_v4.pcre2
    pkgsx86_64_v4.perl
    # pkgsx86_64_v4.python3
    pkgsx86_64_v4.readline
    pkgsx86_64_v4.sqlite
    pkgsx86_64_v4.tzdata
    pkgsx86_64_v4.util-linux
    pkgsx86_64_v4.which
    pkgsx86_64_v4.xz
    pkgsx86_64_v4.zlib
    pkgsx86_64_v4.zstd

    # neomutt
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
  ];
}
