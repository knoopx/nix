{pkgs, ...}: {
  home.packages = with pkgs; [
    # alvr
    # dosbox
    # gamescope
    # gamescope-session
    # hydra-launcher
    # lime3ds
    # mame-tools
    # melonDS
    # nstool
    # nsz
    # opengamepadui
    # pcsx2
    # protonup
    # rpcs3
    # skyscraper
    # wiiudownloader
    # wineWowPackages.waylandFull
    # xemu
    cemu
    es-de
    pegasus-frontend
    retroarch-custom
    ryujinx
    umu-launcher
  ];

  xdg.configFile."pegasus-frontend/themes/gameOS" = {
    recursive = true;
    source = pkgs.pegasus-theme-gameos;
  };

  xdg.configFile."pegasus-frontend/settings.txt".text = ''
    general.theme: themes/gameOS/
    general.verify-files: false
    general.input-mouse-support: true
    general.fullscreen: true
    providers.pegasus_media.enabled: true
    providers.steam.enabled: false
    providers.gog.enabled: false
    providers.es2.enabled: false
    providers.logiqx.enabled: false
    providers.lutris.enabled: false
    providers.skraper.enabled: true
    keys.page-up: PgUp,GamepadL2
    keys.page-down: PgDown,GamepadR2
    keys.prev-page: Q,A,GamepadL1
    keys.next-page: E,D,GamepadR1
    keys.menu: F1,GamepadStart
    keys.filters: F,GamepadY
    keys.details: I,GamepadX
    keys.cancel: Esc,Backspace,GamepadA
    keys.accept: Return,Enter,GamepadB
  '';
}
