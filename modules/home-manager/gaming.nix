{
  pkgs,
  config,
  ...
}: let
  # panda3ds = pkgs.libretro.mkLibretroCore {
  #   core = "panda3ds";
  #   version = "3787358bdae41d5532ccd00c8998a527ae949949";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "jonian";
  #     repo = "libretro-panda3ds";
  #     rev = "3787358bdae41d5532ccd00c8998a527ae949949";
  #     sha256 = "sha256-iQVzfQcYUjrWXVOzsMrFgDqH4wnQSvHeMBk33QzT//0=";
  #   };
  # };
  custom = {
    # pegasus-frontend = pkgs.pegasus-frontend.overrideAttrs (origAttrs: {
    #   src = pkgs.fetchFromGitHub {
    #     owner = "pixl-os";
    #     repo = "pegasus-frontend";
    #     rev = "f140fa7a067a03860d863da0baa6e1e1f51ae9e0";
    #     fetchSubmodules = true;
    #     hash = "sha256-HYGsZU6zHG2N5KV73T09Lh04OOziWuZS4uadMzBpgXs=";
    #   };
    # });
    retroarch = pkgs.retroarch.withCores (
      cores:
        with cores; [
          # beetle-ngp
          # beetle-pce
          # beetle-psx
          # beetle-saturn
          # beetle-supergrafx
          # beetle-vb
          # beetle-wswan
          # bluemsx
          # bsnes
          # bsnes-hd
          # freeintv
          # fuse
          # handy
          # hatari
          # mame
          # picodrive
          # prosystem
          # stella
          dosbox-pure
          citra
          dolphin
          fbneo
          flycast
          gambatte
          genesis-plus-gx
          melonds
          mesen
          mgba
          # mupen64plus
          pcsx2
          ppsspp
          puae
          snes9x
          # panda3ds
        ]
    );
  };

  launchers = with pkgs; [
    es-de
    pegasus-frontend
    # lutris
    # steam
    # bottles
  ];

  games = with pkgs; [
    # liftoff
    # supermeatboy
    # uncrashed
    # brothers-a-tale-of-two-sons-remake
    # celeste
    # driver-san-francisco
    # mindustry-wayland
    # worldofgoo
    factorio-space-age
  ];

  emulators = with pkgs; [
    # xemu
    # dosbox
    # melonDS
    # rpcs3
    # pcsx2
    # lime3ds
    ryujinx
    # citron-emu
    cemu
    custom.retroarch
  ];

  tools = with pkgs; [
    # wiiudownloader
    hydra-launcher
    # skyscraper
    # alvr
    # protonup
    # wineWowPackages.waylandFull
    nsz
    # umu
    wine
    citron-emu
    # gamescope
    # gamescope-session
    # opengamepadui
    mame-tools
    nstool
  ];
in {
  imports = [
    ./emulation
  ];

  home.packages = launchers ++ emulators ++ games ++ tools;

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
