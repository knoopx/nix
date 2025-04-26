{
  lib,
  defaults,
  ...
}:
lib.mkIf defaults.wm.gnome {
  dconf.settings = {
    "org/gnome/shell/extensions/paperwm" = {
      animation-time = 0.1;
      default-focus-mode = 1;
      disable-topbar-styling = true;
      gesture-enabled = false;
      minimap-scale = 0.0;
      open-window-position = 0;
      overview-ensure-viewport-animation = 1;
      selection-border-radius-bottom = 15;
      selection-border-radius-top = 15;
      selection-border-size = 10;
      show-focus-mode-icon = false;
      show-open-position-icon = false;
      show-workspace-indicator = false;
      use-default-background = true;

      # restore-attach-modal-dialogs = "";
      # restore-edge-tiling = "";
      # restore-keybinds = ''
      #   {}
      # '';
      # restore-workspaces-only-on-primary = "";
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      move-left = [
        "<Control><Super>comma"
        "<Shift><Super>comma"
        "<Control><Super>Left"
        "<Shift><Super>Left"
      ];
      move-right = [
        "<Control><Super>period"
        "<Shift><Super>period"
        "<Control><Super>Right"
        "<Shift><Super>Right"
      ];

      switch-left = [];
      switch-right = [];
      switch-left-loop = ["<Super>Left"];
      switch-right-loop = ["<Super>Right"];

      live-alt-tab = [];
      toggle-scratch-window = [];
      cycle-group = [];
      cycle-group-backward = [];
    };
  };
}
