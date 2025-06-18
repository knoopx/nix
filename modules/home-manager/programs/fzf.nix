{
  nixosConfig,
  lib,
  inputs,
  ...
}: let
  colorMap =
    lib.mapAttrs' (
      k: v: (lib.nameValuePair v "#${nixosConfig.defaults.colorScheme.palette.${k}}")
    )
    inputs.nix-colors.colorSchemes.catppuccin-mocha.palette;

  fromMocha = color: lib.mkForce colorMap."${color}";
in {
  programs.fzf = {
    enable = true;
    colors = {
      "bg" = fromMocha "1e1e2e";
      "bg+" = fromMocha "313244";
      "fg" = fromMocha "cdd6f4";
      "fg+" = fromMocha "cdd6f4";
      "header" = fromMocha "f38ba8";
      "hl" = fromMocha "f38ba8";
      "hl+" = fromMocha "f38ba8";
      "info" = fromMocha "cba6f7";
      "marker" = fromMocha "b4befe";
      "pointer" = fromMocha "f5e0dc";
      "prompt" = fromMocha "cba6f7";
      "selected-bg" = fromMocha "45475a";
      "spinner" = fromMocha "f5e0dc";
    };
  };
}
