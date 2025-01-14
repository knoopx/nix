{
  pkgs,
  defaults,
  ...
}: let
  gtk-apps = with pkgs; [
    aider-chat
    # libguestfs
    # orca-slicer
    # vial
    # virt-manager
    # zed-editor
    alpaca
    commit
    czkawka
    f3d
    fclones-gui
    fclones-gui
    file-roller
    ghidra-bin
    # gimp
    gitg
    krita
    livecaptions
    nfoview
    nicotine-plus
    onlyoffice-bin
    plexamp
    prusa-slicer
    transmission_4-gtk
  ];

  cli-apps = with pkgs; [
    # dotnet-netcore
    # libvirt
    # nim
    # nimble
    # rclone
    alejandra
    android-tools
    aria2
    ast-grep
    bash-language-server
    bun
    cargo
    chickenPackages.chickenEggs.xj
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
    # mdfried
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
    ydotool
    rufo
    rust-analyzer
    rustc
    shfmt
    sqlpage
    tokei
    tv
    ultralytics
    uv
    visidata
    xidel
    xsv
    yq
    zq
  ];
in {
  home = {
    packages = gtk-apps ++ cli-apps ++ defaults.gnome.extensions;
  };
}
