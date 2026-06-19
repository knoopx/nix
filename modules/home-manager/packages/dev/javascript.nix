{ pkgs, ... }: {
  home.packages = with pkgs; [
    bun
    pnpm
    nodejs_latest
    typescript-language-server
    typescript-go
  ];
}
