{ pkgs
, inputs
, ...
}:
let
  camper = inputs.camper.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = with pkgs; [
    # ── commented out (available but not installed) ─────────────────────────
    # romie              # ROM library manager for retro gaming handhelds
    # apostrophe         # Distraction-free Markdown editor (GNOME)
    # ascii-draw         # Draw diagrams using ASCII art
    # authenticator      # Two-factor auth code generator (GNOME)
    # balatro            # Digital poker roguelike game
    # cartridges         # GTK4/Libadwaita retro game launcher
    # d-spy              # D-Bus exploration/inspection tool
    # decibels           # Audio player (GNOME)
    # delineate          # View and edit graphs (TUI)
    # dissent            # Third-party Discord client (formerly gtkcord4)
    # eloquent           # Proofreading software (20+ languages)
    # emblem             # Generate project icons/avatars from symbolic icon
    # errands            # Task manager (GNOME)
    # exhibit            # Preview 3D models
    # fclones-gui        # GUI for fclones (file deduplication)
    # foliate            # E-book reader (EPUB, PDF, etc.)
    # gapless            # (unknown GUI app)
    # gearlever          # (unknown GUI app)
    # ghidra             # Advanced reverse engineering framework
    # gnome-feeds        # RSS/Atom feed reader (GNOME)
    # gnome-mahjongg     # Mahjongg solitaire (GNOME)
    # gnome-sudoku       # Sudoku puzzle game (GNOME)
    # google-chrome      # Google Chrome web browser
    # impression         # Create bootable USB drives
    # mission-center     # System resource monitor (CPU, RAM, Disk, Network, GPU)
    # newelle            # AI-powered virtual assistant
    # obsidian           # Markdown-based note-taking and knowledge base
    # parlatype          # Semi-automated transcription tool
    # pipeline           # YouTube/PeerTube video player
    # planify            # Task manager with Todoist sync (GNOME)
    # pods               # Podman desktop container manager
    # recordbox          # Native Instruments DJ software
    # rnote              # Vector drawing/note-taking app
    # showtime           # Fullscreen distraction-free video player (GNOME)
    # sly                # Image editor
    # snapshot           # Camera app for photos/videos (GNOME)
    # varia              # Download manager (aria2-based, Libadwaita)
    # wike               # Wikipedia reader (GNOME)
    # wildcard           # Regular expression tester (GNOME)
    # amberol            # Simple music player (GNOME)

    # ── installed packages ─────────────────────────────────────────────────
    baobab               # Disk usage analyzer (pie chart visualization)
    btrfs-assistant      # Btrfs subvolume and snapshot manager
    czkawka              # Multi-functional file cleaner (duplicates, empties, etc.)
    dconf-editor         # Low-level GNOME settings editor
    drawing              # Vector drawing app (MyPaint fork, GNOME)
    # eog                # Eye of GNOME image viewer (commented)
    evince               # Document viewer (PDF, PostScript, etc.)
    file-roller          # Archive manager (tar, zip, 7z, etc.)
    # geary              # Email client (GNOME, commented)
    gnome-calendar       # Calendar application (GNOME)
    gnome-disk-utility   # Disk manager (format, SMART, benchmarks)
    gnome-secrets        # Password and secret manager (GNOME)
    gnome-weather        # Weather application (GNOME)
    camper               # Custom flake package (camper input)
    loupe                # Image viewer (GNOME, replaces eog)
    nautilus             # File manager (GNOME)
    # onlyoffice-desktopeditors  # Office suite (Word/Excel/PowerPoint, commented)
    # pinta              # Image editor (Paint.NET clone, commented)
    plexamp              # Plex music player (amp/Tidal integration)
    # seahorse           # GPG key manager (commented)
    sushi                # File previewer (GNOME/Nautilus)
    # tolaria            # Markdown knowledge base manager (commented)
    wl-kbptr             # Control mouse pointer with keyboard (Wayland)
    # gnome-graphs       # Data plotting and manipulation tool (commented)
  ];
}
