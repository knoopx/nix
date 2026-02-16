{...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

       return {
         automatically_reload_config = true,
         window_close_confirmation = "NeverPrompt",
         hide_tab_bar_if_only_one_tab = true,
         enable_kitty_keyboard = true,
         keys = {
           {
             key = 'Backspace',
             mods = 'CTRL',
             action = wezterm.action.SendString('\x17'),
           },
           {
             key = 'P',
             mods = 'CTRL|SHIFT',
             action = wezterm.action.DisableDefaultAssignment,
           },
           {
             key = 'Enter',
             mods = 'ALT',
             action = wezterm.action.DisableDefaultAssignment,
           },
         },
       }
    '';
  };
}
