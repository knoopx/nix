{
  pkgs,
  firefox-gnome-theme,
  ...
}: colorScheme:
pkgs.stdenvNoCC.mkDerivation {
  name = "stylix-firefox-theme-gnome";
  src = firefox-gnome-theme;

  buildPhase = with colorScheme; ''
    replacements=(
        "s/--gnome-accent:.*\$/--gnome-accent: #${base07};/"
        "s/--gnome-accent-bg:.*\$/--gnome-accent-bg: #${base07};/"
        "s/--gnome-window-background:.*\$/--gnome-window-background: #${base00};/"
        "s/--gnome-window-color:.*\$/--gnome-window-color: #${base05};/"
        "s/--gnome-view-background:.*\$/--gnome-view-background: #${base00};/"
        "s/--gnome-sidebar-background:.*\$/--gnome-sidebar-background: #${base01};/"
        "s/--gnome-secondary-sidebar-background:.*\$/--gnome-secondary-sidebar-background: #${base01};/"
        "s/--gnome-card-background:.*\$/--gnome-card-background: #${base01};/"
        "s/--gnome-menu-background:.*\$/--gnome-menu-background: #${base01};/"
        "s/--gnome-headerbar-background:.*\$/--gnome-headerbar-background: #${base01};/"
        "s/--gnome-toolbar-icon-fill:.*\$/--gnome-toolbar-icon-fill: #${base05};/"
        "s/--gnome-tabbar-tab-hover-background:.*\$/--gnome-tabbar-tab-hover-background: #${base03};/"
        "s/--gnome-tabbar-tab-active-background:.*\$/--gnome-tabbar-tab-active-background: #${base02};/"
        "s/--gnome-tabbar-tab-active-background-contrast:.*\$/--gnome-tabbar-tab-active-background-contrast: #${base02};/"
        "s/--gnome-tabbar-tab-active-hover-background:.*\$/--gnome-tabbar-tab-active-hover-background: #${base03};/"
        "s/--gnome-tabbar-identity-color-green:.*\$/--gnome-tabbar-identity-color-green: #${base0B};/"
        "s/--gnome-tabbar-identity-color-yellow:.*\$/--gnome-tabbar-identity-color-yellow: #${base0A};/"
        "s/--gnome-tabbar-identity-color-orange:.*\$/--gnome-tabbar-identity-color-orange: #${base09};/"
        "s/--gnome-tabbar-identity-color-red:.*\$/--gnome-tabbar-identity-color-red: #${base08};/"
        "s/--gnome-tabbar-identity-color-purple:.*\$/--gnome-tabbar-identity-color-purple: #${base0E};/"
    )

    for file in theme/colors/*.css; do
        for replace in "''${replacements[@]}"; do
            sed -i "$replace" "$file"
        done
    done
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  meta.homepage = "https://github.com/rafaelmardojai/firefox-theme-gnome/";
}
