{
  nixosConfig,
  lib,
  ...
}: let
  palette = nixosConfig.defaults.colorScheme.palette;

  hexToInt = hex: let
    chars = lib.stringToCharacters hex;
    hexMap = {
      "0" = 0;
      "1" = 1;
      "2" = 2;
      "3" = 3;
      "4" = 4;
      "5" = 5;
      "6" = 6;
      "7" = 7;
      "8" = 8;
      "9" = 9;
      "a" = 10;
      "b" = 11;
      "c" = 12;
      "d" = 13;
      "e" = 14;
      "f" = 15;
      "A" = 10;
      "B" = 11;
      "C" = 12;
      "D" = 13;
      "E" = 14;
      "F" = 15;
    };
  in
    lib.foldl (acc: c: acc * 16 + hexMap.${c}) 0 chars;

  intToHex = n: let
    hexChars = ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f"];
    high = lib.elemAt hexChars (n / 16);
    low = lib.elemAt hexChars (lib.mod n 16);
  in "${high}${low}";

  parseColor = hex: {
    r = hexToInt (builtins.substring 0 2 hex);
    g = hexToInt (builtins.substring 2 2 hex);
    b = hexToInt (builtins.substring 4 2 hex);
  };

  blendChannel = base: accent: amount: let
    result = base + ((accent - base) * amount / 100);
  in
    if result < 0
    then 0
    else if result > 255
    then 255
    else builtins.floor result;

  blendColors = baseHex: accentHex: amount: let
    base = parseColor baseHex;
    accent = parseColor accentHex;
  in "${intToHex (blendChannel base.r accent.r amount)}${intToHex (blendChannel base.g accent.g amount)}${intToHex (blendChannel base.b accent.b amount)}";

  bg = palette.base00;
  red = palette.base08;
  green = palette.base0B;

  minusBg = blendColors bg red 15;
  minusEmphBg = blendColors bg red 25;
  plusBg = blendColors bg green 15;
  plusEmphBg = blendColors bg green 25;
in {
  programs.delta = {
    enable = true;
    options = {
      dark = true;
      syntax-theme = "base16";
      line-numbers = true;
      side-by-side = false;
      navigate = true;

      minus-style = "syntax #${minusBg}";
      minus-emph-style = "syntax #${minusEmphBg}";
      minus-non-emph-style = "syntax #${minusBg}";

      plus-style = "syntax #${plusBg}";
      plus-emph-style = "syntax #${plusEmphBg}";
      plus-non-emph-style = "syntax #${plusBg}";

      line-numbers-minus-style = "#${palette.base08}";
      line-numbers-plus-style = "#${palette.base0B}";
      line-numbers-zero-style = "#${palette.base04}";
      line-numbers-left-style = "#${palette.base04}";
      line-numbers-right-style = "#${palette.base04}";

      file-style = "bold #${palette.base0D}";
      file-decoration-style = "none";

      hunk-header-style = "syntax #${palette.base02}";
      hunk-header-decoration-style = "box #${palette.base04}";
      hunk-header-file-style = "#${palette.base0D}";
      hunk-header-line-number-style = "#${palette.base0B}";

      commit-style = "bold #${palette.base0E}";
      commit-decoration-style = "none";

      blame-palette = "#${palette.base00} #${palette.base01} #${palette.base02}";
      blame-code-style = "syntax";

      merge-conflict-begin-symbol = "▼";
      merge-conflict-end-symbol = "▲";
      merge-conflict-ours-diff-header-style = "bold #${palette.base0D}";
      merge-conflict-theirs-diff-header-style = "bold #${palette.base0E}";
    };
  };
}
