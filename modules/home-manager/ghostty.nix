{
  defaults,
  lib,
  inputs,
  ...
}: let
  colorMap =
    lib.mapAttrs' (
      k: v: (lib.nameValuePair v (defaults.colorScheme.palette.${k}))
    )
    inputs.nix-colors.colorSchemes.catppuccin-mocha.palette;

  fromMocha = color: lib.mkForce colorMap."${color}";
in {
  programs.ghostty = {
    enable = true;
  };

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

  programs.skim = {
    enable = true;
    defaultOptions = with defaults.colorScheme.palette; [
      "--color=fg:#${base05},bg:#${base00},matched:#${base02},matched_bg:#${base0F},current:#${base05},current_bg:#${base03},current_match:#${base00},current_match_bg:#${base06},spinner:#${base0B},info:#${base0E},prompt:#${base0D},cursor:#${base08},selected:#${base0F},header:#${base0C},border:#${base04}"
    ];
  };
}
