{
  pkgs,
  catppuccin-userstyles,
  lib,
  ...
}: colorScheme: let
  lessVarDecl = vars: prefix:
    builtins.concatStringsSep " " (lib.attrsets.mapAttrsToList (
        name: value:
          if builtins.isAttrs value
          then "@${prefix}${name}: { ${lessVarDecl value ""} };"
          else "@${prefix}${name}: ${toString value};"
      )
      vars);

  userStyles = lib.strings.concatStringsSep "," [
    "brave-search"
    "bsky"
    "chatgpt"
    "cinny"
    "duckduckgo"
    "github"
    "google"
    "hacker-news"
    "lobste.rs"
    "nixos-*"
    "npm"
    "ollama"
    "perplexity"
    "reddit"
    "spotify-web"
    "stack-overflow"
    "whatsapp-web"
    "wikipedia"
    "youtube"
  ];

  lessVars = {
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
    sponsorBlock = 1;
  };
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "catppuccin.userstyles.css";
    src = catppuccin-userstyles;
    buildInputs = with pkgs; [lessc];

    buildPhase = ''
      export NODE_PATH=${pkgs.nodePackages.less-plugin-clean-css}/lib/node_modules

      for file in styles/{${userStyles}}/catppuccin.user.less; do
        userstyle=$(cat $file && echo ${lib.strings.escapeShellArg (lessVarDecl lessVars "")})
        echo "$userstyle" | lessc  --source-map-no-annotation --clean-css="-b --s0 --skip-rebase --skip-advanced --skip-aggressive-merging --skip-shorthand-compacting" - >> $out
      done
    '';
  }
