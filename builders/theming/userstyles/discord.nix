{
  pkgs,
  lib,
  ...
}: let
  userstyle = pkgs.fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    sha256 = "sha256-SXFiwmFFOuBR5SEr+Ddfv3IK4dlhKHdwHMkbd4dPiaE=";
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
