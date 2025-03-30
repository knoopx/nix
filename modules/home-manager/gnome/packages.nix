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
    aider-chat.withPlaywright
    alpaca
    commit
    czkawka
    f3d
    fclones-gui
    fclones-gui
    file-roller
    ghidra-bin
    gitg
    nfoview
    nicotine-plus
    onlyoffice-bin
    pinta
    plexamp
    prusa-slicer
    transmission_4-gtk
    zed-editor

    vial
    qmk
    pkgsCross.avr.buildPackages.gcc
  ];

  cli-apps = with pkgs; [
    # chickenPackages.chickenEggs.xj
    # dotnet-netcore
    # libvirt
    # mdfried
    # nim
    # nimble
    # rclone
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
    dotnet-sdk_8
    duckdb
    duperemove
    dwarfs
    fclones
    fdupes
    fq
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
    nushell
    ollamark
    python3
    python3Packages.duckdb
    q-text-as-data
    repl-jq
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
