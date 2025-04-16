{
  pkgs,
  defaults,
  ...
}: let
  gtk-apps = with pkgs; [
    # gimp
    # krita
    # libguestfs
    # livecaptions
    # msty
    # orca-slicer
    # virt-manager
    alpaca
    commit
    czkawka
    f3d
    fclones-gui
    file-roller
    ghidra-bin
    gitg
    nfoview
    nicotine-plus
    onlyoffice-bin
    pinta
    pkgsCross.avr.buildPackages.gcc
    plexamp
    prusa-slicer
    qmk
    transmission_4-gtk
    vial
    zed-editor
  ];

  cli-apps = with pkgs; [
    # chickenPackages.chickenEggs.xj
    # dotnet-netcore
    # libvirt
    # mdfried
    # nim
    # nimble
    # ultralytics
    # universal-android-debloater
    # visidata
    alejandra
    android-tools
    aria2
    ast-grep
    bash-language-server
    bun
    cargo
    clickhouse-cli
    crystal
    csvkit
    csvlens
    dasel
    ddgr
    deno
    docker-compose
    dotnet-sdk_9
    duckdb
    duperemove
    dwarfs
    fclones
    fdupes
    fq
    cromite
    gcalcli
    gojq
    gron
    htmlq
    innoextract
    internetarchive
    jq
    libsecret
    mpv
    nh
    nixd
    nodejs_latest
    notify
    ntfy
    nushell
    ollamark
    pocketbase
    python3
    python3Packages.duckdb
    q-text-as-data
    rclone
    ruby
    ruby-lsp
    rufo
    rust-analyzer
    rustc
    shfmt
    sqlpage
    tokei
    tv
    uv
    xan
    xidel
    ydotool
    yq
    zq
  ];
in {
  home = {
    packages = gtk-apps ++ cli-apps ++ defaults.gnome.extensions;
  };
}
