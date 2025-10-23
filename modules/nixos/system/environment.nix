{...}: {
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      GSK_RENDERER = "ngl";
      SDL_VIDEODRIVER = "wayland";
      
      # Sound theme configuration
      XDG_DATA_DIRS = ["/run/current-system/sw/share"];
      __E_XDG_SOUND_THEME_NAME = "freedesktop";
    };
  };
}
