{
  lib,
  hexToRGB,
  rgbToHex,
}:
with lib; let
  darker = {
    r = 42;
    g = 40;
    b = 0;
  };
  slightDark = {
    r = 19;
    g = 20;
    b = 0;
  };
  slightLight = {
    r = 17;
    g = 13;
    b = 0;
  };
  lighter = {
    r = 30;
    g = 24;
    b = 0;
  };

  applyOffset = rgb: offset: {
    r = rgb.r + offset.r;
    g = rgb.g + offset.g;
    b = rgb.b + offset.b;
  };

  colorVariations = baseColor: let
    isValidHex = match "[0-9a-fA-F]{6}" baseColor != null;
    baseRgbA = hexToRGB baseColor;
    baseRgb = {
      r = elemAt baseRgbA 0;
      g = elemAt baseRgbA 1;
      b = elemAt baseRgbA 2;
    };
  in
    assert assertMsg isValidHex "Invalid hex color format. Please use format 'RRGGBB'"; {
      base4 = rgbToHex (applyOffset baseRgb lighter);
      base3 = rgbToHex (applyOffset baseRgb slightLight);
      base2 = baseColor;
      base1 = rgbToHex (applyOffset baseRgb (mapAttrs (_: v: -v) slightDark));
      base0 = rgbToHex (applyOffset baseRgb (mapAttrs (_: v: -v) darker));
    };
in
  colorVariations
