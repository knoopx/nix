{config, ...}: {
  home = {
    stateVersion = "25.05";
  };

  home.file."run.sh" = {
    executable = true;
    text = ''
      echo $0
    '';
  };

  home.file."roms/test/metadata.txt".text = ''
    collection: Test
    launch: ${config.home.homeDirectory}/run.sh {file.path}

    game: Test
    file: test.txt
  '';

  home.file."roms/test/test.txt".text = "Hello World";

  xdg.configFile."pegasus-frontend/themes/gameOS" = {
    source = fetchTarball {
      url = "https://github.com/PlayingKarrde/gameOS/releases/download/1.10/gameOS.zip";
      sha256 = "sha256:1ph487fnl7ayn5fgzb381fnzw2daj09r7q6hy0papaq579i1knsf";
    };
    recursive = true;
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
    providers.skraper.enabled: false
    keys.page-up: PgUp,GamepadL2
    keys.page-down: PgDown,GamepadR2
    keys.prev-page: Q,A,GamepadL1
    keys.next-page: E,D,GamepadR1
    keys.menu: F1,GamepadStart
    keys.filters: F,GamepadY
    keys.details: I,GamepadX
    keys.cancel: Esc,Backspace,GamepadB
    keys.accept: Return,Enter,GamepadA
  '';

  xdg.configFile."pegasus-frontend/game_dirs.txt".text = ''
    ${config.home.homeDirectory}/roms/test/
  '';
}
