{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # aide
    # aider-chat
    # bambu-studio
    # blender
    # cursor
    # dotnet-netcore
    # fclones-gui
    # firefox
    # floorp
    # libguestfs
    # libvirt
    # motrix
    # nim
    # nimble
    # orca-slicer
    # plasticity
    # prusa-slicer
    # python312Packages.uncompyle6
    # rclone
    # vial
    # virt-manager
    # wineWow64Packages.waylandFull
    # zed-editor
    # alpaca

    alejandra
    android-tools
    aria2
    bash-language-server
    bun
    cargo
    commit
    crystal
    czkawka
    deno
    docker-compose
    dotnet-sdk_8
    duperemove
    dwarfs
    f3d
    fclones
    fclones-gui
    fdupes
    file-roller
    ghidra-bin
    gitg
    # google-chrome
    libsecret
    livecaptions
    mpv
    nfoview
    nh
    nicotine-plus
    nixd
    nodejs_latest
    onlyoffice-bin
    pipx
    python3
    ruby
    # ruby-lsp
    rufo
    rust-analyzer
    rustc
    shfmt
    tokei
    transmission_4-gtk
    uv
    vscode
    krita
    # gimp
    ghostty
    ffmpeg
    (pkgs.stdenv.mkDerivation {
      name = "plexamp-unwrapped";
      version = pkgs.plexamp.version;
      src = pkgs.plexamp.out;

      installPhase = ''
        mkdir -p $out
        cp -r * $out
        rm $out/bin/plexamp
        mv $out/bin/.plexamp-wrapped $out/bin/plexamp
      '';
    })
  ];
}
