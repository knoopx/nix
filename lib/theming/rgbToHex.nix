{lib, ...}: {
  r,
  g,
  b,
}:
with lib; let
  clampRgb = value:
    if value < 0
    then 0
    else if value > 255
    then 255
    else value;

  toHex = n: fixedWidthString 2 "0" (toLower (toHexString (clampRgb n)));
in "${toHex r}${toHex g}${toHex b}"
