{
  pkgs,
  defaults,
  ...
}: {
  environment = {
    variables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      GSK_RENDERER = "ngl";
    };
  };
}
