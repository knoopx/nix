{
  pkgs,
  colorScheme,
  ...
}: let
  hexToHSL = x: pkgs.theming.lib.hexToHSL x "%";
in
  pkgs.writeTextFile {
    name = "immich.userstyle.css";
    # --accent-main-000: 18 50.4% 47.5%;
    # --accent-main-100: 18 56.8% 43.5%;
    # --accent-main-200: 19 58.3% 40.4%;
    # --accent-main-900: 16 41.3% 18%;
    # --accent-pro-000: 251 84.6% 74.5%;
    # --accent-pro-100: 251 40.2% 54.1%;
    # --accent-pro-200: 251 40% 45.1%;
    # --accent-pro-900: 250 25.3% 19.4%;
    # --accent-secondary-100: 210 74.8% 49.8%;
    # --accent-secondary-200: 210 74.2% 42.1%;
    # --accent-secondary-900: 210 19.5% 18%;
    # --danger-000: 5 69.4% 72.9%;
    # --danger-100: 5 79.4% 70.8%;
    # --danger-200: 5 53.6% 44.8%;
    # --danger-900: 0 21.4% 17.6%;
    # --oncolor-100: var(--constant-slate-000);
    # --oncolor-200: 60 6.7% 97.1%;
    # --oncolor-300: 60 6.7% 97.1%;
    # --text-000: #b4befe;
    # --text-100: 50 23.1% 94.9%;
    # --text-200: 60 5.5% 89.2%;
    # --text-300: 47 8.4% 79%;
    # --text-400: 48 9.6% 69.2%;
    # --text-500: 45 6.3% 62.9%;
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
