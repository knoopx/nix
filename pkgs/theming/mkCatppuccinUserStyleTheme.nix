{
  pkgs,
  lib,
  inputs,
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
  };

  colorMap =
    (lib.mapAttrs' (
        k: v: (lib.nameValuePair v (colorScheme.${k}))
      )
      inputs.nix-colors.colorSchemes.catppuccin-mocha.palette)
    // {
      "f5c2e7" = colorScheme.base0F; # pink
      "eba0ac" = colorScheme.base08; # maroon
      "89dceb" = colorScheme.base0C; # sky
      "74c7ec" = colorScheme.base0D; # sapphire

      "9399b2" = colorScheme.base06; # overlay2
      "7f849c" = colorScheme.base05; # overlay1
      "6c7086" = colorScheme.base04; # overlay0
      "11111b" = colorScheme.base01; # crust

      "bac2de" = colorScheme.base05; # subtext1
      "a6adc8" = colorScheme.base06; # subtext2
    };
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "catppuccin.userstyles.css";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "userstyles";
      rev = "958476784e42e7562d6ed527b6a48cf8620752ce";
      sha256 = "sha256-1HkIURfa+dkrKb8jF9U6fM+EsjuyulAAN0/Gxhumito=";
    };
    buildInputs = with pkgs; [lessc];

    # ${lib.getExe pkgs.theming.matchThemeColors} "$file" > "$file"
    # substituteInPlace $file ${lib.concatStringsSep " " (lib.mapAttrsToList (k: v: lib.strings.escapeShellArgs ["--replace-warn" k v]) colorMap)}
    buildPhase = ''
      export NODE_PATH=${pkgs.nodePackages.less-plugin-clean-css}/lib/node_modules

      for file in styles/{${userStyles}}/catppuccin.user.less; do
        userstyle=$(cat $file && echo ${lib.strings.escapeShellArg (lessVarDecl lessVars "")})
        echo "$userstyle" | lessc  --source-map-no-annotation --clean-css="-b --s0 --skip-rebase --skip-advanced --skip-aggressive-merging --skip-shorthand-compacting" - >> $out
      done
      substituteInPlace $out --replace-fail "Unsupported GitHub theme detected! Please switch to the default light/dark theme via the GitHub Appearance settings to get the best experience for the Catppuccin GitHub userstyle." ""
    '';
  }
