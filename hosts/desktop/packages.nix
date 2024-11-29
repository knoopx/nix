{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # aide
    # aider-chat
    # amberol
    # bambu-studio
    # blender
    # cursor
    # dotnet-netcore
    # fclones-gui
    # firefox
    # floorp
    # gnome-boxes
    # gnome-system-monitor
    # inputs.nixpkgs-update.packages.${pkgs.system}.nixpkgs-update
    # libguestfs
    # libvirt
    # loupe
    # motrix
    # nim
    # nimble
    # orca-slicer
    # plasticity
    # prusa-slicer
    # python312Packages.uncompyle6
    # rclone
    # showtime
    # vial
    # virt-manager
    # wineWow64Packages.waylandFull
    # zed-editor
    alejandra
    alpaca
    android-tools
    aria2
    authenticator
    bash-language-server
    bun
    cargo
    commit
    crystal
    czkawka
    decibels
    deno
    docker-compose
    dotnet-sdk_8
    drawing
    duperemove
    dwarfs
    eog
    evince
    f3d
    fclones
    fclones-gui
    fdupes
    file-roller
    ghidra-bin
    gitg
    gnome-calendar
    gnome-control-center
    gnome-secrets
    google-chrome
    libsecret
    livecaptions
    mpv
    nautilus
    nfoview
    nh
    nicotine-plus
    nil
    nixd
    nodejs_latest
    onlyoffice-bin
    pipx
    python3
    python311
    ruby
    ruby-lsp
    rufo
    rust-analyzer
    rustc
    seahorse
    shfmt
    snapshot
    tokei
    transmission_4-gtk
    uv
    vscode
    xdg-desktop-portal-gnome
    zen-browser
  ];
}
