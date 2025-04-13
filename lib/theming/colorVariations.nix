{
  lib,
  hexToRGB,
  rgbToHex,
}:
with lib; let
  darkest = {
    r = 42;
    g = 40;
    b = 0;
  };
  darker = {
    r = 19;
    g = 20;
    b = 0;
  };
  lighter = {
    r = 17;
    g = 13;
    b = 0;
  };
  lightest = {
    r = 30;
    g = 24;
    b = 0;
  };

  offset = rgb: offset: {
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
    assert assertMsg isValidHex "Invalid hex color format. Please use format 'RRGGBB'"; [
      (rgbToHex (offset baseRgb lightest))
      (rgbToHex (offset baseRgb lighter))
      baseColor
      (rgbToHex (offset baseRgb (mapAttrs (_: v: -v) darker)))
      (rgbToHex (offset baseRgb (mapAttrs (_: v: -v) darkest)))
    ];
in
  colorVariations
