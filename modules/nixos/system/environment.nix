{
  pkgs,
  defaults,
  ...
}: {
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      GSK_RENDERER = "ngl";
      SDL_VIDEODRIVER = "wayland";
    };
  };
}
