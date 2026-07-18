{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    _7zz # 7-Zip archive tool (compression/decompression)
    aria2 # Multi-protocol, multi-source downloader
    bluez # Bluetooth protocol stack (Linux)
    bluez-tools # Additional Bluetooth utilities (bluetoothd, etc.)
    brotab # Browser tab session manager (save/restore tabs)
    bubblewrap # Unprivileged sandboxing tool (Flatpak dependency)
    clang-tools # LLVM/Clang tooling (clang-format, clang-tidy, etc.)
    dconf # Desktop settings database (gsettings backend)
    dmidecode # Hardware information from DMI/SMBIOS tables
    duckdb # Embedded analytical SQL database
    exiftool # Read/write file metadata (EXIF, IPTC, XMP, etc.)
    fclones # File deduplication tool (finds similar/identical files)
    ffmpeg # Multimedia framework (audio/video conversion)
    findutils # File finding utilities (find, xargs, locate)
    http-nu # HTTP client (Nushell implementation)
    imagemagick # Image creation/editing/conversion suite
    inetutils # Network utilities (ftp, telnet, talk, rexec, rlogin)
    inotify-tools # Filesystem event monitoring (inotifywait, inotifywatch)
    jc # JSON converter (parses output from many CLI tools)
    jq # Command-line JSON processor
    kuva # Image viewer for Wayland
    lshw # Hardware lister (detailed system hardware info)
    lsof # List open files and network connections
    nh # Nix helper (manage NixOS/Home Manager config)
    nvd # nix package version diff
    p7zip # 7-Zip implementation (archive tool)
    pciutils # PCI device utilities (lspci)
    pcre # Perl-Compatible Regular Expressions library
    plocate # Fast file locator (updated mlocate)
    poppler-utils # PDF utilities (pdftotext, pdfinfo, pdfunite, etc.)
    ripgrep # Fast grep alternative (Rust-based)
    rsync # Remote/local file synchronization
    socat # Socket relay (connects two data channels)
    sox # Sound processor (audio conversion/effects)
    sqlite # Embedded SQL database engine
    tmux # Terminal multiplexer (sessions, panes, windows)
    tree # Directory tree visualizer
    usbutils # USB device utilities (lsusb)
    util-linux # Essential Linux utilities (lsblk, mount, fdisk, etc.)
    websocat # WebSocket client/server (like socat for WS)
    wirelesstools # Wireless network utilities (iwconfig, etc.)
    wl-clipboard # Wayland clipboard tools (wl-copy, wl-paste)
    wshowkeys # Wayland key/mouse event viewer
    xxd # Hex dumper/editor
    secretspec

    # ── custom/overlay packages ────────────────────────────────────────────
    google-authenticator-qr-decode # Decode QR codes for Google Authenticator setup
    pick-project # Project picker (custom tool)
    pick-document # Document picker (custom tool)
    inbox # Inbox tool (custom tool)
    events # Events tool (custom tool)
    project-summary # Project summary tool (custom tool)
  ];
}
