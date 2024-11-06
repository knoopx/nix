{
  pkgs,
  defaults,
  ...
}: let
  gtk-apps = with pkgs; [
  ];
in {
  home = {
    packages = gtk-apps ++ defaults.gnome.extensions;
  };
}
