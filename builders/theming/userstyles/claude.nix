{
  pkgs,
  colorScheme,
  ...
}: let
  hexToHSL = x: pkgs.lib.theming.hexToHSL x "%";
in
  pkgs.writeTextFile {
    name = "immich.userstyle.css";

    text = with colorScheme; ''
      @-moz-document domain("claude.ai") {
        * { background-image: none; }

        :root {
          --font-system: system-ui;
          --font-sans-serif: monospace;
          --font-serif: var(--font-system);
          --font-tiempos: var(--font-system);

          --accent-brand: ${hexToHSL base07};
          --accent-secondary-000: ${hexToHSL base06};
          --bg-000: ${hexToHSL base01};
          --bg-100: ${hexToHSL base00};
          --bg-200: ${hexToHSL base02};
          --bg-300: ${hexToHSL base03};
          --bg-400: ${hexToHSL base04};
          --bg-500: ${hexToHSL base05};
          --border-100: ${hexToHSL base07};
          --border-200: ${hexToHSL base07};
          --border-300: ${hexToHSL base07};
          --border-400: ${hexToHSL base07};
        }
      }
    '';
  }
