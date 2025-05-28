{
  pkgs,
  defaults,
  ...
}: let
  customCSS = with defaults.colorScheme.palette;
    pkgs.writeTextFile {
      name = "glance.css";
      text = ''
        .weather-column-daylight {
          background: linear-gradient(0deg, transparent 30px, #${base02}) !important;
        }
      '';
    };

  assets = pkgs.stdenv.mkDerivation {
    name = "glance-assets";
    phases = ["buildPhase"];
    buildPhase = ''
      mkdir -p $out
      cp ${customCSS} $out/${customCSS.name}
    '';
  };

  hexToHSL = x: pkgs.lib.theming.hexToHSL x "";
in {
  stylix.targets.glance.enable = false;

  services.glance = {
    enable = true;

    settings = {
      server = {
        port = 9000;
        assets-path = assets;
      };
      branding = {
        hide-footer = true;
        logo-text = "K";
      };
      theme = with defaults.colorScheme.palette; {
        custom-css-file = "assets/${customCSS.name}";
        background-color = hexToHSL base00;
        primary-color = hexToHSL base07;
        positive-color = hexToHSL base0B;
        negative-color = hexToHSL base08;
      };
    };
  };
}
