{ pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    _7zz # 7-Zip archive tool (compression/decompression)
    aria2 # Multi-protocol, multi-source downloader
    bat # Binary cat with syntax highlighting and pager
    binutils # GNU binary utilities (as, ld, nm, ar, etc.)

    brotab # Browser tab session manager (save/restore tabs)
    bubblewrap # Unprivileged sandboxing tool (Flatpak dependency)
    cacert # CA certificates bundle for TLS verification
    clang-tools # LLVM/Clang tooling (clang-format, clang-tidy, etc.)
    curl # Command-line URL transfer
    dconf # Desktop settings database (gsettings backend)
    diffutils # Diff, cmp, patch utilities

    dnsutils # DNS lookup utilities (dig, nslookup, host, etc.)
    duckdb # Embedded analytical SQL database
    events # Events tool (custom tool)
    exiftool # Read/write file metadata (EXIF, IPTC, XMP, etc.)
    eza # Modern replacement for ls
    fclones # File deduplication tool (finds similar/identical files)
    fd # Fast find alternative
    ffmpeg # Multimedia framework (audio/video conversion)
    file # File type identification
    findutils # File finding utilities (find, xargs, locate)
    git # Distributed version control system
    git-lfs # Git Large File Storage extension
    gnugrep # GNU grep
    gnused # GNU sed
    gnutar # GNU tar
    gnutls # GNU TLS toolkit
    google-authenticator-qr-decode # Decode QR codes for Google Authenticator setup
    gzip # GNU compression
    helix # Modern modal text editor
    http-nu # HTTP client (Nushell implementation)
    imagemagick # Image creation/editing/conversion suite
    inbox # Inbox tool (custom tool)
    inetutils # Network utilities (ftp, telnet, talk, rexec, rlogin)
    inotify-tools # Filesystem event monitoring (inotifywait, inotifywatch)
    jc # JSON converter (parses output from many CLI tools)
    jq # Command-line JSON processor

    lrzip # Long-range file compression (LZMA + RZIP)

    lsof # List open files and network connections
    micro # Modern terminal-based text editor
    nh # Nix helper (manage NixOS/Home Manager config)

    nvd # nix package version diff
    openssl # OpenSSL toolkit
    p7zip # 7-Zip implementation (archive tool)
    patch # Patch utility

    pcre # Perl-Compatible Regular Expressions library
    pick-document # Document picker (custom tool)
    pick-project # Project picker (custom tool)
    plocate # Fast file locator (updated mlocate)
    poppler-utils # PDF utilities (pdftotext, pdfinfo, pdfunite, etc.)
    project-summary # Project summary tool (custom tool)
    psmisc # Process utilities (pgrep, pkill, pstree, etc.)
    ripgrep # Fast grep alternative (Rust-based)
    rsync # Remote/local file synchronization
    secretspec # Declarative secrets management
    socat # Socket relay (connects two data channels)
    sox # Sound processor (audio conversion/effects)
    sqlite # Embedded SQL database engine
    tmux # Terminal multiplexer (sessions, panes, windows)
    trash-cli # Move files to trash instead of deleting
    tree # Directory tree visualizer
    tzdata # Timezone data
    unrar # RAR archive extraction
    unzip # ZIP archive extraction

    util-linux # Essential Linux utilities (lsblk, mount, fdisk, etc.)
    websocat # WebSocket client/server (like socat for WS)
    wget # Non-interactive network downloader
    which # Locate commands in PATH
    whois # WHOIS domain lookup
    wirelesstools # Wireless network utilities (iwconfig, etc.)

    xxd # Hex dumper/editor
    yazi # Terminal file manager
    zip # ZIP archive creation
  ];
}
