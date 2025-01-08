{
  lib,
  hexToDec,
}: let
  hexToHSL = hex: let
    rgb = {
      r = (hexToDec (builtins.substring 0 2 hex)) / 255.0;
      g = (hexToDec (builtins.substring 2 2 hex)) / 255.0;
      b = (hexToDec (builtins.substring 4 2 hex)) / 255.0;
    };
    maxValue = lib.trivial.max rgb.r (lib.trivial.max rgb.g rgb.b);
    minValue = lib.trivial.min rgb.r (lib.trivial.min rgb.g rgb.b);
    l = (maxValue + minValue) / 2;
    delta = maxValue - minValue;
    s =
      if delta == 0.0
      then 0
      else if l <= 0.5
      then delta / (maxValue + minValue)
      else delta / (2 - maxValue - minValue);
    h_raw =
      if delta == 0.0
      then 0
      else if maxValue == rgb.r
      then 60 * ((rgb.g - rgb.b) / delta)
      else if maxValue == rgb.g
      then 60 * (2 + (rgb.b - rgb.r) / delta)
      else 60 * (4 + (rgb.r - rgb.g) / delta);
    h =
      if h_raw < 0
      then h_raw + 360
      else h_raw;
  in "${toString (builtins.floor h)} ${toString (builtins.floor (s * 100))} ${toString (builtins.floor (l * 100))}";
in
  hexToHSL
