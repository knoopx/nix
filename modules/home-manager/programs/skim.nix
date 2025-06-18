{nixosConfig, ...}: {
  programs.skim = {
    enable = true;
    defaultOptions = with nixosConfig.defaults.colorScheme.palette; [
      "--color=fg:#${base05},bg:#${base00},matched:#${base02},matched_bg:#${base0F},current:#${base05},current_bg:#${base03},current_match:#${base00},current_match_bg:#${base06},spinner:#${base0B},info:#${base0E},prompt:#${base0D},cursor:#${base08},selected:#${base0F},header:#${base0C},border:#${base04}"
    ];
  };
}
