{
  nixosConfig,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    extensions = [];
    extraPackages = [];
    userSettings = {
      ui_font_size = lib.mkForce 16;
      buffer_font_size = lib.mkForce 12;
      buffer_font_family = "JetBrainsMono Nerd Font";
      ui_font_weight = 400;
      buffer_font_weight = 300;
      buffer_line_height = "standard";
      terminal = {
        font_size = 11;
        font_weight = 100;
        line_height = "standard";
      };
      agent_servers = {
        OpenCode = {
          type = "custom";
          command = "/etc/profiles/per-user/${nixosConfig.defaults.username}/bin/oc";
          args = ["acp"];
          env = {};
        };
      };
      context_servers = {};
      agent = {
        always_allow_tool_actions = true;
        default_model = {
          model = "gpt-4.1";
          provider = "copilot_chat";
        };
      };
      features = {
        edit_prediction_provider = "copilot";
      };
      icon_theme = "Catppuccin Mocha";
      telemetry = {
        metrics = false;
      };
      theme = "Base16 custom";
      vim_mode = false;
    };
    userKeymaps = [];
    userTasks = [];
    installRemoteServer = false;
  };
}
