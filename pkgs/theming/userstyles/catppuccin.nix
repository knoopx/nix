{
  pkgs,
  lib,
  ...
}: let
  vars = {
    lightFlavor = "mocha";
    darkFlavor = "mocha";
    accentColor = "lavender";
    contrastColor = "@accentColor";
    highlightColor = "@accentColor";
    graphUseAccentColor = 1;
    bg-opacity = 0.2;
    bg-blur = "20px";
    zen = 0;
    styleVideoPlayer = 1;
    stylePieces = 1;
    hideProfilePictures = 0;
    additions = 0;
    urls = "localhost";
    darkenShadows = 1;
    colorizeLogo = 0;
    lighterMessages = 0;
    highlight-redirect = 0;
    logo = 1;
    oled = 0;
  };

  userStyles = lib.strings.concatStringsSep "," [
    "chatgpt"
    "duckduckgo"
    "github"
    "google"
    "nixos-*"
    "npm"
    "ollama"
    "whatsapp-web"
    "reddit"
    "spotify-web"
    "youtube"
    "bsky"
    # "wikipedia"
  ];
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "catppuccin.userstyle.css";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "userstyles";
      rev = "958476784e42e7562d6ed527b6a48cf8620752ce";
      sha256 = "sha256-1HkIURfa+dkrKb8jF9U6fM+EsjuyulAAN0/Gxhumito=";
    };
    buildInputs = with pkgs; [lessc];
    buildPhase = ''
      export NODE_PATH=${pkgs.nodePackages.less-plugin-clean-css}/lib/node_modules

      for file in styles/{${userStyles}}/catppuccin.user.less; do
        (echo "${lib.strings.concatMapStrings (x: ";" + x) (lib.attrsets.mapAttrsToList (k: v: "@${k}: ${toString v};") vars)}" && cat $file) | lessc  --source-map-no-annotation --clean-css="-b --s0 --skip-rebase --skip-advanced --skip-aggressive-merging --skip-shorthand-compacting" - >> $out
      done
      substituteInPlace $out --replace-fail "Unsupported GitHub theme detected! Please switch to the default light/dark theme via the GitHub Appearance settings to get the best experience for the Catppuccin GitHub userstyle." ""
    '';
  }
