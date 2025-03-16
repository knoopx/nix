{
  pkgs,
  defaults,
  lib,
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

  hexToHSL = x: pkgs.theming.lib.hexToHSL x "";
in {
  imports = [
    ./pages.nix
  ];

  services.glance = {
    enable = true;

    package = pkgs.glance.overrideAttrs (before: {
      preConfigure = ''
        ${lib.getExe pkgs.ast-grep} run -U -l js internal/glance/static/js/main.js \
        -p 'function setupCollapsibleLists() { $$$ }' \
        --rewrite 'function setupCollapsibleLists() {
          const collapsibleLists = document.querySelectorAll(".list.collapsible-container");
          for (let i = 0; i < collapsibleLists.length; i++) {
            const list = collapsibleLists[i];

            if (list.dataset.collapseAfter === undefined) {
              continue;
            }

            const maxHeight = 400;
            list.style.maxHeight = `''${maxHeight}px`;
            list.style.overflowY = "auto";
            list.style.position = "relative";
          }
        }'
      '';
    });

    settings = {
      server = {
        port = 9000;
        host = "localhost";
        assets-path = assets;
      };
      branding = {
        hide-footer = true;
        logo-text = "K";
      };
      theme = with defaults.colorScheme.palette; {
        custom-css-file = "assets/${customCSS.name}";
        # contrast-multiplier = 1.2;
        background-color = hexToHSL base00;
        primary-color = hexToHSL base07;
        positive-color = hexToHSL base0B;
        negative-color = hexToHSL base08;
      };
    };
  };
}
