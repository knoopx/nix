{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    android-tools
    aria2
    bash-language-server
    bun
    deno
    cargo
    crystal
    docker-compose
    fclones
    fdupes
    duperemove
    # virt-manager
    # libvirt
    # libguestfs
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
    # onlyoffice-bin
    # baobab
    # prusa-slicer
  ];
}
