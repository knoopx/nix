{pkgs, ...}: let
  username = "knoopx";
in {
  inherit username;
  password = username;
  full-name = "Victor Martinez";
  location = "Vilassar de Mar";
  primary-email = "knoopx@gmail.com";

  # cat $(nix-build --no-out-link '<nixpkgs>' -A xkeyboard_config)/etc/X11/xkb/rules/base.lst
  keyMap = "eu";
  timeZone = "Europe/Madrid";
  defaultLocale = "en_US.UTF-8";
  region = "es_ES.UTF-8";

  avatar-image =
    (pkgs.fetchurl {
      url = "https://gravatar.com/userimage/10402619/9d663d9a46ad2c752bf6cfeb93cff4fd.jpeg?size=512";
      sha256 = "sha256-raMsbyJQgf7JPMvZtAFOBIBwFg8V7HpmtERO9J/50qQ=";
    })
    .outPath;

  editor = "re.sonny.Commit";

  pubKeys = {
    url = "https://github.com/${username}.keys";
    sha256 = "sha256-385krE9Aoea23aQ3FJo2kpPtRrIOwxxXCCt43gHEo0Q=";
  };

  # fc-list : family
  fonts = {
    sizes.applications = 11;

    sansSerif = {
      name = "Inter";
      package = pkgs.inter;
    };

    serif = {
      name = "Roboto Slab";
      package = pkgs.roboto;
    };

    emoji = {
      name = "Twitter Color Emoji";
      package = pkgs.twitter-color-emoji;
    };

    monospace = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
  };

  # https://catppuccin.com/palette
  # https://nico-i.github.io/scheme-viewer/base16/
  # https://github.com/tinted-theming/base16-schemes/
  # open file:///etc/stylix/palette.html

  #ffff03
  #fad000
  #ffc600
  #ff9d00
  #ff7200
  #ffee80
  #faefa5
  #ffb454
  #3b5364
  #193549  #35ad68
  #aaaaaa
  #5c5c61
  #3ad900
  #8efa00
  #a5ff90
  #80ffbb
  #92fc79
  #ff7300
  #fb94ff
  #ff628c
  #f16e6b
  #ec3a37
  #ee3a43
  #ff2c70
  #e1efff
  #e5e4fb
  #cec5ff
  #a599e9
  #8aadf4
  #7580b8
  #7870ab
  #ad70fc
  #b362ff
  #5d37f0
  #7857fe
  #7e46df
  #6943ff
  #4d21fc
  #494685
  #5706a2
  #2d2b55
  #292952
  #28284e
  #262650
  #25254b
  #222244
  #222145
  #1f1f41
  #1e1e3f
  #1a1a35
  #191935
  #191830
  #161633
  #15152b
  #15152a
  #131327
  #80fcff
  #9effff

  colorScheme =
    # #181825 #131327
    # #1e1e2e #1e1e3f
    # #313244 #25254b #3b5364
    # #45475a #2d2b55
    # #585b70 #494685
    # -
    # #cdd6f4 #cec5ff #e1efff
    # #f5e0dc #e5e4fb #faefa5 #
    # #b4befe #a599e9 #cec5ff #4d21fc
    # -
    # #f38ba8 #ff628c #ec3a37 #ff000d
    # #fab387 #ff7200 #ff9d00 #ffb454
    # #f9e2af #ffee80 #faefa5
    # #a6e3a1 #a5ff90 #00ff00 #3ad900
    # #94e2d5 #9effff #80fcff
    # #8aadf4 #a599e9# #fad000
    # #cba6f7  #faefa5 #ad70fc
    # #f2cdcd  #fb94ff #faefa5
    {
      name = "custom";
      palette = {
        base00 = "131327";
        base01 = "1e1e3f";
        base02 = "25254b";
        base03 = "2d2b55";
        base04 = "494685";

        base05 = "e1efff"; # text
        base06 = "e5e4fb";
        base07 = "fad000";

        base08 = "ff628c";
        base09 = "ffb454";
        base0A = "ffee80";
        base0B = "a5ff90";
        base0C = "80fcff";
        base0D = "fad000";
        base0E = "faefa5";
        base0F = "fb94ff";
      };
    };

  display = {
    width = 1920 * 2;
    height = 1080 * 2;
    windowSize = [1240 900];
    sidebarWidth = 200;
  };
}
