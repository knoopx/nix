{
  pkgs,
  nix-colors,
}: let
  # open file:///etc/stylix/palette.html
  # https://github.com/tinted-theming/base16-schemes/
  # https://catppuccin.com/palette
  colorScheme =
    pkgs.lib.attrsets.recursiveUpdate
    nix-colors.colorSchemes.catppuccin-mocha
    {
      palette.base0E = "fad000";
    };

  username = "knoopx";
in {
  # cat $(nix-build --no-out-link '<nixpkgs>' -A xkeyboard_config)/etc/X11/xkb/rules/base.lst
  keyMap = "eu";
  timeZone = "Europe/Madrid";
  defaultLocale = "en_US.UTF-8";
  region = "es_ES.UTF-8";

  location = "Vilassar de Mar";

  full-name = "Victor Martinez";

  avatar-image =
    (pkgs.fetchurl {
      url = "https://gravatar.com/userimage/10402619/9d663d9a46ad2c752bf6cfeb93cff4fd.jpeg?size=512";
      sha256 = "sha256-raMsbyJQgf7JPMvZtAFOBIBwFg8V7HpmtERO9J/50qQ=";
    })
    .outPath;

  primary-email = "knoopx@gmail.com";
  work-email = "victor@jacoti.com";

  editor = "re.sonny.Commit";

  pubKeys = {
    url = "https://github.com/${username}.keys";
    sha256 = "sha256-385krE9Aoea23aQ3FJo2kpPtRrIOwxxXCCt43gHEo0Q=";
  };

  inherit username;
  password = username;

  easyeffects = {
    irs = "MaxxAudio Pro 128K MP3 4.Music w MaxxSpace";
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

  display = {
    width = 1920 * 2;
    height = 1080 * 2;
  };

  gnome = {
    windowSize = [1240 900];
    sidebarWidth = 200;
    extensions = with pkgs.gnomeExtensions; [
      hot-edge
      user-themes
      caffeine
      panel-corners
      astra-monitor
      steal-my-focus-window
      # useless-gaps
      # tailscale-qs
    ];
  };

  inherit colorScheme;
}
