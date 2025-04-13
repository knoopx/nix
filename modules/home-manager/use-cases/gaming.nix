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
    # factorio-space-age
  ];

  emulators = with pkgs; [
    # cemu
    # dosbox
    # lime3ds
    # melonDS
    # pcsx2
    # rpcs3
    # ryujinx
    # xemu
    retroarch-custom
  ];

  tools = with pkgs; [
    # alvr
    # gamescope
    # gamescope-session
    # hydra-launcher
    # mame-tools
    # opengamepadui
    # protonup
    # skyscraper
    # wiiudownloader
    # wineWowPackages.waylandFull
    nstool
    nsz
    umu-launcher
  ];
in {
  home.packages = launchers ++ emulators ++ games ++ tools;

  xdg.configFile."pegasus-frontend/themes/gameOS" = {
    recursive = true;
    source = pkgs.stdenvNoCC.mkDerivation {
      name = "gameOS";
      src = fetchTarball {
        url = "https://github.com/PlayingKarrde/gameOS/archive/7a5a5223ff7371d0747a7c5d3a3b8f2f5e36b4f2.zip";
        sha256 = "sha256:1mwrk8dk6rbr72nr32bnn524agjq01x1fyih1yxm7m5h8rxlh6hh";
      };
      installPhase = "cp -R ./ $out";
      patches = [
        (pkgs.fetchurl {
          url = "https://github.com/PlayingKarrde/gameOS/compare/7a5a5223ff7371d0747a7c5d3a3b8f2f5e36b4f2...knoopx:gameOS:master.diff";
          sha256 = "sha256-uW1zwsTEywt6BawpPcVvlL7Z2GRnEiqnQEc4KqT1HYo=";
        })
      ];
    };
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
