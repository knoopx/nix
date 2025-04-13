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
    # (aider-chat.withOptional
    #   {
    #     withAll = true;
    #   })
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
    rclone
    # ultralytics
    # universal-android-debloater
    # visidata
    alejandra
    android-tools
    (cromite.overrideAttrs
      {
        desktopItems = [
          (makeDesktopItem {
            name = "cromite";
            exec = "cromite %U";
            icon = "google-chrome";
            startupWMClass = "chromium-browser";
            genericName = "Cromite";
            desktopName = "Cromite";
            categories = [
              "Application"
              "Network"
              "WebBrowser"
            ];
          })
        ];

        postFixup = ''
          rm $out/bin/cromite
          makeWrapper $out/share/cromite/chrome $out/bin/cromite \
            --prefix QT_PLUGIN_PATH  : "${qt6.qtbase}/lib/qt-6/plugins" \
            --prefix QT_PLUGIN_PATH  : "${qt6.qtwayland}/lib/qt-6/plugins" \
            --prefix NIXPKGS_QT6_QML_IMPORT_PATH : "${qt6.qtwayland}/lib/qt-6/qml" \
            --prefix LD_LIBRARY_PATH : "$rpath" \
            --prefix PATH            : "$binpath" \
            --suffix PATH            : "${lib.makeBinPath [xdg-utils]}" \
            --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addDriverRunpath.driverLink}/share" \
            --set CHROME_WRAPPER  "cromite" \
            --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --disable-features=WaylandFractionalScaleV1"
        '';
      })

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
    pocketbase
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
    notify
    ntfy
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
