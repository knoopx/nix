{pkgs, ...}: {
  home.packages = with pkgs; [
    ruby
    ruby-lsp
    rufo
    solargraph
    rubocop
  ];
}
