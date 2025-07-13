{
  pkgs,
  lib,
  ...
}: let
  userstyle = pkgs.fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    sha256 = "sha256-1NIL4TbkHBZirwc4Uj+N+98I+a3B0KltfO6WQ1No9QQ=";
  };
in
  pkgs.writeTextFile {
    name = "discord.userstyle.css";
    text = ''
      @-moz-document domain("discord.com") {
        ${lib.readFile userstyle}
      };
    '';
  }
