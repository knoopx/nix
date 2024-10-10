{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    onlyoffice-bin
    alejandra
    android-tools
    aria2
    baobab
    bash-language-server
    bun
    cargo
    crystal
    docker-compose
    fclones
    fdupes
    duperemove
    # virt-manager
    # libvirt
    libguestfs
    libsecret
    nh
    nil
    nim
    nimble
    nixd
    nodejs
    pipx
    python3
    python311
    ruby
    ruby-lsp
    dotnet-sdk_8
    # dotnet-netcore
    rufo
    rust-analyzer
    rustc
    shfmt
    tokei
    uv

    # orca-slicer
    # prusa-slicer
  ];
}
