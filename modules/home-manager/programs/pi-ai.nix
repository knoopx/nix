{
  lib,
  nixosConfig,
  ...
}:
with lib; let
  palette = nixosConfig.defaults.colorScheme.palette;

  theme = {
    "$schema" = "https://raw.githubusercontent.com/badlogic/pi-mono/main/packages/coding-agent/theme-schema.json";
    name = "nix-defaults";
    vars = {
      base00 = "#${palette.base00}";
      base01 = "#${palette.base01}";
      base02 = "#${palette.base02}";
      base03 = "#${palette.base03}";
      base04 = "#${palette.base04}";
      base05 = "#${palette.base05}";
      base06 = "#${palette.base06}";
      base07 = "#${palette.base07}";
      base08 = "#${palette.base08}";
      base09 = "#${palette.base09}";
      base0A = "#${palette.base0A}";
      base0B = "#${palette.base0B}";
      base0C = "#${palette.base0C}";
      base0D = "#${palette.base0D}";
      base0E = "#${palette.base0E}";
      base0F = "#${palette.base0F}";
    };
    colors = {
      accent = "base0D";
      border = "base03";
      borderAccent = "base0D";
      borderMuted = "base02";
      success = "base0B";
      error = "base08";
      warning = "base0A";
      muted = "base04";
      dim = "base03";
      text = "base05";
      thinkingText = "base04";

      selectedBg = "base02";
      userMessageBg = "base01";
      userMessageText = "base05";
      customMessageBg = "base01";
      customMessageText = "base05";
      customMessageLabel = "base0E";
      toolPendingBg = "base01";
      toolSuccessBg = "base01";
      toolErrorBg = "base01";
      toolTitle = "base0D";
      toolOutput = "base06";

      mdHeading = "base0D";
      mdLink = "base0C";
      mdLinkUrl = "base03";
      mdCode = "base0B";
      mdCodeBlock = "base05";
      mdCodeBlockBorder = "base03";
      mdQuote = "base04";
      mdQuoteBorder = "base03";
      mdHr = "base03";
      mdListBullet = "base0D";

      toolDiffAdded = "base0B";
      toolDiffRemoved = "base08";
      toolDiffContext = "base04";

      syntaxComment = "base03";
      syntaxKeyword = "base0E";
      syntaxFunction = "base0D";
      syntaxVariable = "base08";
      syntaxString = "base0B";
      syntaxNumber = "base09";
      syntaxType = "base0A";
      syntaxOperator = "base0C";
      syntaxPunctuation = "base06";

      thinkingOff = "base03";
      thinkingMinimal = "base04";
      thinkingLow = "base0D";
      thinkingMedium = "base0C";
      thinkingHigh = "base0E";
      thinkingXhigh = "base0F";

      bashMode = "base08";
    };
  };
in {
  home.file.".pi/agent/themes/custom.json".text = builtins.toJSON theme;
}
