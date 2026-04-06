{nixosConfig, ...}: let
  colors = nixosConfig.defaults.colorScheme.palette;
in {
  programs.skim = {
    enable = true;
    defaultOptions = [
      "--color=fg:#${colors.base05},bg:#${colors.base00},matched:#${colors.base0D},matched_bg:#${colors.base01},current:#${colors.base05},current_bg:#${colors.base02},current_match:#${colors.base05},current_match_bg:#${colors.base0D},spinner:#${colors.base05},info:#${colors.base04},prompt:#${colors.base0D},cursor:#${colors.base0D},selected:#${colors.base0D},header:#${colors.base0D},border:#${colors.base02}"
    ];
  };
}
