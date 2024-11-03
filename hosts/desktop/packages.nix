{
  pkgs,
  inputs,
  ...
}: let
  cursor =
    pkgs
    .code-cursor
    .overrideAttrs
    (oldAttr: {
      installPhase =
        oldAttr.installPhase
        + ''
          rm $out/bin/cursor
          mv $out/bin/.cursor-wrapped $out/bin/cursor
        '';
    });
in {
  environment.systemPackages = with pkgs; [
    # inputs.nixpkgs-update.packages.${pkgs.system}.nixpkgs-update
    # (callPackage ../../pkgs/nfoview.nix {})
    (callPackage ../../pkgs/zen-browser.nix {})
    # aider-chat
    # amberol
    # blender
    # dotnet-netcore
    drawing
    # fclones-gui
    # firefox
    # ghidra-bin
    # gnome-boxes
    # gnome-system-monitor
    # libguestfs
    # libvirt
    mpv
    onlyoffice-bin
    # orca-slicer
    # plasticity
    # python312Packages.uncompyle6
    # rclone
    seahorse
    gnome-secrets
    # vial
    # virt-manager
    # wineWow64Packages.waylandFull
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
    deno
    docker-compose
    dotnet-sdk_8
    duperemove
    f3d
    fclones
    fdupes
    file-roller
    gitg
    gnome-calendar
    gnome-control-center
    decibels
    file-roller
    evince
    loupe
    showtime
    snapshot
    google-chrome
    libsecret
    livecaptions
    nautilus
    nh
    nicotine-plus
    nil
    nim
    nimble
    nixd
    nodejs
    pipx
    prusa-slicer
    python3
    python311
    ruby
    livecaptions
    ruby-lsp
    rufo
    rust-analyzer
    rustc
    shfmt
    tokei
    transmission_4-gtk
    uv
    vscode
    xdg-desktop-portal-gnome
    zed-editor
    cursor
  ];
}
