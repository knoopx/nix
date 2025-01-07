{
  pkgs,
  defaults,
  ...
}: let
  plexamp = pkgs.stdenvNoCC.mkDerivation {
    name = "plexamp-unwrapped";
    version = pkgs.plexamp.version;
    src = pkgs.plexamp.out;

    buildInputs = with pkgs; [
      makeWrapper
    ];

    installPhase = ''
      mkdir -p $out
      cp -r * $out
      rm $out/bin/plexamp
      mv $out/bin/.plexamp-wrapped $out/bin/plexamp
      # makeWrapper $out/bin/plexamp $out/bin/.plexamp-wrapped --disable-features=WaylandFractionalScaleV1
      wrapProgram "$out/bin/plexamp" --add-flags "--disable-features=WaylandFractionalScaleV1"
    '';
  };

  gtk-apps = with pkgs; [
    # aide
    # aider-chat
    # alpaca
    # bambu-studio
    # blender
    # cursor
    # fclones-gui
    # firefox
    # floorp
    # gimp
    # libguestfs
    # motrix
    # orca-slicer
    # plasticity
    # prusa-slicer
    # python312Packages.uncompyle6
    # vial
    # virt-manager
    # wineWow64Packages.waylandFull
    # zed-editor
    commit
    czkawka
    f3d
    fclones-gui
    file-roller
    ghidra-bin
    # ghostty
    gitg
    krita
    livecaptions
    nfoview
    nicotine-plus
    onlyoffice-bin
    plexamp
    transmission_4-gtk
  ];

  cli-apps = with pkgs; [
    # dotnet-netcore
    # libvirt
    # nim
    # nimble
    # rclone
    # ruby-lsp
    alejandra
    android-tools
    aria2
    bash-language-server
    bun
    cargo
    crystal
    csvkit
    deno
    docker-compose
    dotnet-sdk_8
    duckdb
    duperemove
    dwarfs
    fclones
    fdupes
    ffmpeg
    fq
    htmlq
    jq
    libsecret
    mpv
    nh
    nixd
    nodejs_latest
    nushell
    python3
    python3Packages.duckdb
    q-text-as-data
    ruby
    rufo
    rust-analyzer
    rustc
    shfmt
    sqlpage
    tokei
    uv
    xidel
    yq
    zq
    gron
    chickenPackages.chickenEggs.xj
    clickhouse-cli
    internetarchive
    dasel
    gcalcli
    csvlens
    tv
    xsv
    visidata
    innoextract
    ast-grep
  ];
in {
  home = {
    packages = gtk-apps ++ cli-apps ++ defaults.gnome.extensions;
  };
}
