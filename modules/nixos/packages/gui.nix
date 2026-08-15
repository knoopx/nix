{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # amberol            # Simple music player (GNOME)
    # apostrophe         # Distraction-free Markdown editor (GNOME)
    # ascii-draw         # Draw diagrams using ASCII art
    # authenticator      # Two-factor auth code generator (GNOME)
    # balatro            # Digital poker roguelike game
    # btrfs-assistant # Btrfs subvolume and snapshot manager
    # cartridges         # GTK4/Libadwaita retro game launcher
    # d-spy              # D-Bus exploration/inspection tool
    # dconf-editor # Low-level GNOME settings editor
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
    # geary              # Email client (GNOME, commented)
    # ghidra             # Advanced reverse engineering framework
    # gnome-feeds        # RSS/Atom feed reader (GNOME)
    # gnome-graphs       # Data plotting and manipulation tool (commented)
    # gnome-mahjongg     # Mahjongg solitaire (GNOME)
    # gnome-secrets # Password and secret manager (GNOME)
    # gnome-sudoku       # Sudoku puzzle game (GNOME)
    # google-chrome      # Google Chrome web browser
    # impression         # Create bootable USB drives
    # lmstudio
    # mission-center     # System resource monitor (CPU, RAM, Disk, Network, GPU)
    # newelle            # AI-powered virtual assistant
    # newsflash
    # obsidian           # Markdown-based note-taking and knowledge base
    # onlyoffice-desktopeditors  # Office suite (Word/Excel/PowerPoint, commented)
    # parlatype          # Semi-automated transcription tool
    # picard
    # pinta              # Image editor (Paint.NET clone, commented)
    # pipeline           # YouTube/PeerTube video player
    # planify            # Task manager with Todoist sync (GNOME)
    # pods               # Podman desktop container manager
    # recordbox          # Native Instruments DJ software
    # rnote              # Vector drawing/note-taking app
    # romie              # ROM library manager for retro gaming handhelds
    # seahorse           # GPG key manager (commented)
    # showtime           # Fullscreen distraction-free video player (GNOME)
    # sly                # Image editor
    # snapshot           # Camera app for photos/videos (GNOME)
    # sushi # File previewer (GNOME/Nautilus)
    # tolaria            # Markdown knowledge base manager (commented)
    # varia              # Download manager (aria2-based, Libadwaita)
    # vial
    # wike               # Wikipedia reader (GNOME)
    # wildcard           # Regular expression tester (GNOME)
    baobab # Disk usage analyzer (pie chart visualization)
    kuva # Image viewer for Wayland
    drawing # Vector drawing app (MyPaint fork, GNOME)
    evince # Document viewer (PDF, PostScript, etc.)
    file-roller # Archive manager (tar, zip, 7z, etc.)
    gnome-calendar # Calendar application (GNOME)
    gnome-disk-utility # Disk manager (format, SMART, benchmarks)
    gnome-weather # Weather application (GNOME)
    nautilus # File manager (GNOME)
    plexamp # Plex music player (amp/Tidal integration)
    swayimg # Image viewer for Wayland (swaywm)
  ];
}
