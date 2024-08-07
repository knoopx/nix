{
  pkgs,
  config,
  ...
}: {
  # TODO: link config.services.silverbullet.spaceDir ~/Documents/SilverBullet
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "sb" ''
      pushd ${config.services.silverbullet.spaceDir}
      fd --type f -e md . | grep -v Library/Core | grep -v Templates | awk '{print substr($0, 1, length($0)-3) "\t" $0}' | sort --ignore-case | fzf --reverse --with-nth=1 --preview-window=right:70% \
          --delimiter='\t' \
          --preview 'glow --style=dark {2}' \
          --bind="enter:execute(sb-open {2})"
      popd
    '')

    (writeShellScriptBin "sb-open" ''
      # set -l base_url "https://silverbullet.knoopx.net"
      # set -l url_path (echo $path | sed 's/\.md$//' | sed 's/ /%20/g')
      # xdg-open "$base_url/$url_path"
      micro $1
    '')

    # orca-slicer
    alejandra
    android-tools
    aria2
    baobab
    bash-language-server
    bun
    cargo
    crystal
    docker-compose
    dosbox
    fclones
    libsecret
    lutris
    mame-tools
    nh
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
    ruby-lsp
    rufo
    rust-analyzer
    rustc
    ryujinx
    shfmt
    standardnotes
    tokei
    uv
    xemu
  ];
}
