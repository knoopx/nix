{
  pkgs,
  nix-colors,
  ...
}: let
  username = "knoopx";
in {
  inherit username;
  password = username;
  full-name = "Victor Martinez";
  location = "Vilassar de Mar";
  primary-email = "knoopx@gmail.com";
  work-email = "victor@jacoti.com";

  wm = {
    gnome = false;
    niri = true;
  };

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
  colorScheme =
    pkgs.lib.attrsets.recursiveUpdate
    nix-colors.colorSchemes.catppuccin-mocha
    {
      palette.base0D = "fad000";
    };

  display = {
    width = 1920 * 2;
    height = 1080 * 2;
    windowSize = [1240 900];
    sidebarWidth = 200;
  };
}
