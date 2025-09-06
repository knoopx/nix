{
  nixosConfig,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = false;
    extensions = []; # VSCode: extensions.ignoreRecommendations = true
    extraPackages = [];
    userSettings = {
      theme = "Base16 custom";
      icon_theme = "Catppuccin Mocha";
      features = {
        edit_prediction_provider = "copilot";
      };
      agent = {
        always_allow_tool_actions = true;
        default_model = {
          provider = "copilot_chat";
          model = "gpt-4.1";
        };
      };
      telemetry = {
        metrics = false;
      };
      ui_font_size = lib.mkForce 12;
      buffer_font_size = lib.mkForce 11;
      buffer_font_family = nixosConfig.defaults.fonts.monospace.name;
      ui_font_family = nixosConfig.defaults.fonts.sansSerif.name;
      vim_mode = false;
    };
    userKeymaps = [];
    userTasks = [];
    installRemoteServer = false;
  };
}
