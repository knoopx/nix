{
  pkgs,
  inputs,
  lib,
  colorScheme,
  ...
}: let
  base00 = inputs.nix-colors.lib.conversions.hexToRGB colorScheme.palette.base00;
  r = (lib.elemAt base00 0) / 255.0;
  g = (lib.elemAt base00 1) / 255.0;
  b = (lib.elemAt base00 2) / 255.0;
in
  pkgs.stdenv.mkDerivation {
    name = "plymouth-theme-custom";
    src = pkgs.adi1090x-plymouth-themes;
    buildInputs = [pkgs.plymouth pkgs.imagemagick];
    installPhase = ''
      mkdir -p $out/share/plymouth/themes/custom
      magick \( -size 1x16 ${builtins.concatStringsSep " " (map (hex: "xc:\"#${hex}\"") (builtins.attrValues colorScheme.palette))} +append -scale 200x20! \) palette.png

      cp -r --no-preserve=mode $src/share/plymouth/themes/cuts/*.png $out/share/plymouth/themes/custom/
      magick mogrify -dither FloydSteinberg -remap palette.png $out/share/plymouth/themes/custom/*.png
      magick mogrify -transparent "#${colorScheme.palette.base00}" $out/share/plymouth/themes/custom/*.png

      cp ${./custom.plymouth} $out/share/plymouth/themes/custom/custom.plymouth
      cp ${./custom.script} $out/share/plymouth/themes/custom/custom.script
      sed -i "s|@out@|$out|g; s|@r@|${toString r}|g; s|@g@|${toString g}|g; s|@b@|${toString b}|g" $out/share/plymouth/themes/custom/custom.plymouth $out/share/plymouth/themes/custom/custom.script
    '';
  }
