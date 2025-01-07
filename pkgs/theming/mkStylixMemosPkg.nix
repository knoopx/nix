{
  pkgs,
  lib,
  ...
}: colorScheme: let
  name = "memos";
  version = "0.23.0";

  # css = with defaults.colorScheme.palette; ''
  #   .dark\:bg-zinc-900 {
  #     background-color: #${base00} !important;
  #   }

  #   .bg-primary-darker,
  #   .dark\:bg-primary-darker {
  #     background-color: #${base0D} !important;
  #   }

  #   .dark\:bg-zinc-800 {
  #     background-color: #${base02} !important;
  #   }

  #   .dark\:border-zinc-800 {
  #     border-color: #${base02} !important;
  #   }

  #   .dark\:border-zinc-700 {
  #     border-color: #${base03} !important;
  #   }

  #   .text-base,
  #   .text-gray-400, .dark\:text-gray-400
  #   .text-gray-500, .dark\:text-gray-500
  #   {
  #     color: #${base05};
  #   }
  # '';

  # https://github.com/usememos/memos/blob/main/web/tailwind.config.js
  colors = with colorScheme; {
    gray = {
      "400" = "#${base05}";
      "500" = "#${base05}";
    };
    zinc = {
      "900" = "#${base00}";
      "800" = "#${base02}";
      "700" = "#${base03}";
      "200" = "#${base05}";
    };
    red = {
      "600" = "#${base08}";
    };
    blue = {
      "600" = "#${base0D}";
    };
    primary = {
      DEFAULT = "#${base05}";
      dark = "#${base05}";
      darker = "#${base05}";
    };
    success = {
      DEFAULT = "#${base0B}";
      dark = "#${base0B}";
      darker = "#${base0B}";
    };
    danger = {
      DEFAULT = "#${base08}";
      dark = "#${base08}";
      darker = "#${base08}";
    };
    warning = {
      DEFAULT = "#${base0A}";
      dark = "#${base0A}";
      darker = "#${base0A}";
    };
  };

  src = pkgs.fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-2uluBnJIcfdezqa5/wSF6Cp7SUUp3YYDqKTOtKlYbCY=";
  };

  frontend = pkgs.stdenvNoCC.mkDerivation {
    name = "${name}-deps";
    inherit src;
    nativeBuildInputs = with pkgs; [nodejs pnpm cacert];
    buildPhase = ''
      export HOME=$(pwd)
      cd web
      pnpm i

      ${lib.getExe pkgs.ast-grep} run -U -l js tailwind.config.js -p '{colors: $$$, $$$R}' --rewrite '{colors: ${builtins.toJSON colors}, $$$R}'
      node_modules/.bin/vite build --mode release --outDir=$out --emptyOutDir
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-KzCfNgVcAC7a04TrYrRfcJ7cZL4UF6ATp14zGmJEB1A=";
  };
in
  pkgs.buildGoModule {
    inherit name version src;
    doCheck = false;
    vendorHash = "sha256-YaLhvqcuCJpvkSpd1lh2GXE0+c0Zcw3xQ2v1/zn2AZE=";
    prePatch = ''
      rm -rf server/router/frontend/dist
      cp -r ${frontend} server/router/frontend/dist
    '';
    meta = {mainProgram = "memos";};
  }
