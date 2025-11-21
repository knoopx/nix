{
  pkgs,
  inputs,
  lib,
  colorScheme,
  ...
}: let
  base00Rgb = inputs.nix-colors.lib.conversions.hexToRGB colorScheme.palette.base00;
  r = (lib.elemAt base00Rgb 0) / 255.0;
  g = (lib.elemAt base00Rgb 1) / 255.0;
  b = (lib.elemAt base00Rgb 2) / 255.0;
in
  pkgs.stdenv.mkDerivation {
    name = "plymouth-theme-custom";
    src = pkgs.adi1090x-plymouth-themes;
    buildInputs = [pkgs.plymouth pkgs.lutgen pkgs.imagemagick];
    installPhase = ''
      mkdir -p $out/share/plymouth/themes/custom
      lutgen apply $src/share/plymouth/themes/cuts/*.png -o $out/share/plymouth/themes/custom/ -- ${builtins.concatStringsSep " " (builtins.attrValues colorScheme.palette)}
      for png in $out/share/plymouth/themes/custom/*.png; do
        magick mogrify -colors 4 "$png"
      done
      cp ${./custom.plymouth} $out/share/plymouth/themes/custom/custom.plymouth
      cp ${./custom.script} $out/share/plymouth/themes/custom/custom.script
      sed -i "s|@out@|$out|g; s|@r@|${toString r}|g; s|@g@|${toString g}|g; s|@b@|${toString b}|g" $out/share/plymouth/themes/custom/custom.plymouth $out/share/plymouth/themes/custom/custom.script
    '';
  }
