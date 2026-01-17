{pkgs, ...}: {
  home.packages = with pkgs; [
    nushell
    nushellPlugins.polars
    nushellPlugins.query
    nushellPlugins.desktop_notifications
    nushellPlugins.highlight
    nushellPlugins.skim
    nufmt
  ];
}
