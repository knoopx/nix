{
  pkgs,
  nixosConfig,
  ...
}: {
  home.file.".face" = {source = nixosConfig.defaults.avatarImage;};
  xdg.configFile."gnome-mcp/config.json".source = pkgs.writeText "gnome-mcp-server-config.json" (
    builtins.toJSON {
      resources = {
        calendar = {
          days_ahead = 60;
          days_behind = 7;
        };
        tasks = {
          include_completed = false;
          include_cancelled = false;
          due_within_days = 7;
        };
      };
      tools = {
        notifications = {};
        audio = {
          volume_step = 5;
        };
      };
    }
  );
}
