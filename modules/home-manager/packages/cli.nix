{ pkgs
, inputs
, ...
}: {
  home.packages = with pkgs; [
    # ── commented out (available but not installed) ─────────────────────────

    # asciinema            # Terminal session recorder
    # atuin                # Shell history manager with sync and search
    # axel                 # Multi-connection download accelerator
    # bandwhich             # Terminal bandwidth utilization monitor
    # bash                 # Bourne Again Shell
    # bison                # Parser generator (compiler tool)
    # black                # Opinionated Python code formatter
    # btrfs-snap           # Btrfs snapshot management tool
    # ccache               # Compiler cache for faster rebuilds
    # circumflex           # Hacker News terminal client
    # csvkit               # CSV toolkit (csvgrep, csvcut, csvjoin, etc.)
    # csvlens              # Interactive CSV/TSV viewer in terminal
    # dasel                # Data selector for JSON, YAML, TOML (like jq)
    # dawn                 # Vectorized 3D PostScript processor (unfree)
    # debugedit            # Debug info editor for ELF binaries
    # distrobox            # Container-based development environments
    # duperemove           # Eliminate duplicate data blocks in Btrfs/XFS
    # dwarfs               # Deduplicating filesystem tools
    # efibootmgr           # EFI boot manager configuration
    # elfutils             # ELF file utilities (eu-readelf, eu-strings, etc.)
    # fastfetch            # System information fetcher (neofetch alternative)
    # fdupes               # Duplicate file finder/remover
    # figurine             # Print your name in ASCII art style
    # fx                   # jq alternative for JSON processing
    # gcalcli              # Google Calendar CLI client
    # gettext              # Internationalization (i18n) tooling
    # glib                 # GLib utility programs (gio, gresource, etc.)
    # glibc                # GNU C Library (runtime)
    # glibc.dev            # GNU C Library development headers
    # glibc.static         # Static GNU C Library
    # glibc.static.dev     # Static GNU C Library development files
    # glow                 # Terminal Markdown renderer
    # goose-cli            # SQL migration tool
    # gritql               # Code search/query language engine
    # gum                  # Shell UI tool (prompts, spinners, filters)
    # harlequin            # SQL client (broken, installed as uv tool)
    # hdparm               # Hard disk parameter utility
    # iftop                # Real-time network bandwidth monitor
    inspect # Semantic git change inspector (Ataraxy-Labs)
    # iperf                # Network performance benchmark tool
    # isort                # Python import statement sorter
    # just                 # Command runner (like make, uses Justfile)
    # less                 # Terminal file pager
    # libarchive           # Archive library (tar, cpio, rar, etc.)
    # libelf               # ELF file manipulation library
    # libffi               # Foreign Function Interface library
    # libgcc               # GCC runtime library
    # libgccjit            # GCC JIT compiler library
    # libgcrypt            # Cryptographic library
    # libnotify             # Desktop notification library
    # libusb1              # USB device communication library
    # libuv                # Multi-platform async I/O library
    # libxml2              # XML parsing library
    # lm_sensors           # Hardware monitoring (temperatures, voltages, fans)
    # logrotate            # Log file rotation utility
    # lychee               # Link checker for files and websites
    # lz4                  # Extremely fast lossless compression
    # lzo                  # Fast lossless compression library
    # m4                   # GNU Macro processor
    # mcat                 # cat for documents, images, videos in terminal
    # mdtt                 # Markdown table formatter
    # miller               # Data processing tool (awk/sed for named fields)
    # nap                  # Code snippets manager in terminal
    # nb                   # Personal notebook CLI
    # nethogs              # Per-process network bandwidth monitor
    # ox                   # Terminal-based text editor (Rust)
    # patchelf             # ELF file patcher (modify rpath, interpreter, etc.)
    # pcre2                # Perl-Compatible Regular Expressions library
    # perl                 # Perl programming language
    # posting              # HTTP client (broken, installed as uv tool)
    # python313Packages.markitdown  # Convert documents (PDF, HTML, etc.) to Markdown
    # rage                 # age encryption/decryption CLI (Rust implementation)
    # ranger               # Terminal file manager with Vi keys
    # rclone               # Cloud storage sync/copy tool (S3, GCS, etc.)
    # reader               # Web page readability extractor for CLI
    # readline             # Line editing library
    # rich-cli             # Rich text formatting CLI
    # sd                   # sed alternative (simpler syntax)
    # shfmt                # Shell script formatter
    # skate                # Syncable personal key-value store (charmb)
    # skopeo               # Container image inspector/copier
    # smartmontools        # SMART disk health monitoring (smartctl)
    # smassh               # Monkeytype clone (typing test)
    # speedtest-cli        # Internet speed test CLI
    # swayimg              # Image viewer for Wayland (swaywm)
    # sysz                 # System information display
    # tab                  # Programming language / shell calculator
    # tabiew               # Interactive database/CSV viewer
    # taskwarrior3         # Command-line task manager
    # typst                # Modern typesetting system (LaTeX alternative)
    # umu-launcher         # Windows game launcher (Proton wrapper)
    # up                   # REPL tool
    # visidata             # Interactive data explorer and sorter
    # vllm                 # LLM inference engine
    # w3m                  # Text-based web browser
    # walk                 # Terminal file manager (Go)
    # weave                # Visual merge tool for jj (Ataraxy-Labs)
    # wlrctl               # Wayland compositor control utility
    # xq-xml               # XML query tool (jq-like for XML)
    # xz                   # LZMA compression tool
    # yq                   # YAML/XML/TOML processor (Python implementation)
    # yq-go                # YAML/XML/TOML processor (Go implementation)
    # yt-dlp               # YouTube/video downloader
    # zk                   # Zettelkasten note-taking system
    # zlib                 # Compression library
    # zstd                 # Zstandard compression tool

    # ── installed packages ─────────────────────────────────────────────────
    _7zz # 7-Zip archive tool (compression/decompression)
    android-tools # Android debugging bridge (adb) and fastboot
    aria2 # Multi-protocol, multi-source downloader
    bluez # Bluetooth protocol stack (Linux)
    bluez-tools # Additional Bluetooth utilities (bluetoothd, etc.)
    brotab # Browser tab session manager (save/restore tabs)
    bubblewrap # Unprivileged sandboxing tool (Flatpak dependency)
    caligula # TUI disk imaging tool (dd alternative)
    clang-tools # LLVM/Clang tooling (clang-format, clang-tidy, etc.)
    dconf # Desktop settings database (gsettings backend)
    dmidecode # Hardware information from DMI/SMBIOS tables
    duckdb # Embedded analytical SQL database
    exiftool # Read/write file metadata (EXIF, IPTC, XMP, etc.)
    fclones # File deduplication tool (finds similar/identical files)
    ffmpeg # Multimedia framework (audio/video conversion)
    findutils # File finding utilities (find, xargs, locate)
    gogcli # GOG.com game library CLI client
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
    nvd # Neovim debugger
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
    wacli # WhatsApp CLI (sync, search, send messages)
    websocat # WebSocket client/server (like socat for WS)
    wirelesstools # Wireless network utilities (iwconfig, etc.)
    wl-clipboard # Wayland clipboard tools (wl-copy, wl-paste)
    wshowkeys # Wayland key/mouse event viewer
    xxd # Hex dumper/editor

    # ── custom/overlay packages ────────────────────────────────────────────
    google-authenticator-qr-decode # Decode QR codes for Google Authenticator setup
    tts # Text-to-speech CLI
    pick-project # Project picker (custom tool)
    pick-document # Document picker (custom tool)
    inbox # Inbox tool (custom tool)
    events # Events tool (custom tool)
    project-summary # Project summary tool (custom tool)
  ];
}
