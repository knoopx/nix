{
  config,
  nixosConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.vicinae;

  vicinae = let
    src = pkgs.fetchFromGitHub {
      owner = "knoopx";
      repo = "vicinae";
      rev = "5cd32987fca634a8a4505edeea8420f4bbde9769";
      hash = "sha256-6tgUvmc5a7XF9XtSd2qIYZcADq1/fGBht8b6MWKPTOc=";
    };

    # Prepare node_modules for api folder
    apiDeps = pkgs.fetchNpmDeps {
      src = src + /api;
      hash = "sha256-7rsaGjs1wMe0zx+/BD1Mx7DQj3IAEZQvdS768jVLl3E=";
    };

    # Prepare node_modules for extension-manager folder
    extensionManagerDeps = pkgs.fetchNpmDeps {
      src = src + /extension-manager;
      hash = "sha256-7kScWi1ySUBTDsGQqgpt2wYmujP9Mlwq3x2FKOlGwgo=";
    };

    ts-protoc-gen-wrapper = pkgs.writeShellScriptBin "protoc-gen-ts_proto" ''
      exec node /build/source/vicinae-upstream/api/node_modules/.bin/protoc-gen-ts_proto
    '';
  in
    pkgs.stdenv.mkDerivation rec {
      pname = "vicinae";
      version = src.rev;

      inherit src;

      cmakeFlags = [
        "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
        "-DCMAKE_INSTALL_DATAROOTDIR=share"
        "-DCMAKE_INSTALL_BINDIR=bin"
        "-DCMAKE_INSTALL_LIBDIR=lib"
      ];

      nativeBuildInputs = with pkgs; [
        ts-protoc-gen-wrapper
        extensionManagerDeps
        autoPatchelfHook
        cmake
        ninja
        nodejs
        pkg-config
        qt6.wrapQtAppsHook
        rapidfuzz-cpp
        protoc-gen-js
        protobuf
        grpc-tools
        which
        rsync
        breakpointHook
        typescript
      ];

      buildInputs = with pkgs; [
        qt6.qtbase
        qt6.qtsvg
        qt6.qttools
        qt6.qtwayland
        qt6.qtdeclarative
        qt6.qt5compat
        wayland
        kdePackages.qtkeychain
        kdePackages.layer-shell-qt
        minizip
        grpc-tools
        protobuf
        nodejs
        minizip-ng
        cmark-gfm
        libqalculate
      ];

      configurePhase = ''
        cmake -G Ninja -B build $cmakeFlags
      '';

      buildPhase = ''
        export npm_config_cache=${apiDeps}
        cd /build/source/api
        npm i --ignore-scripts
        patchShebangs /build/source/api
        npm rebuild --foreground-scripts
        export npm_config_cache=${extensionManagerDeps}
        cd /build/source/extension-manager
        npm i --ignore-scripts
        patchShebangs /build/source/extension-manager
        npm rebuild --foreground-scripts
        cd /build/source
        substituteInPlace cmake/ExtensionApi.cmake cmake/ExtensionManager.cmake --replace-fail "COMMAND npm install" ""
        cmake --build build
        cd /build/source
      '';

      postFixup = ''
        wrapProgram $out/bin/vicinae \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath buildInputs} \
        --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [
          nodejs
          qt6.qtwayland
          wayland
        ])}
      '';

      installPhase = ''
        cmake --install build
      '';
    };
in {
  options.services.vicinae = {
    enable = mkEnableOption "vicinae launcher daemon" // {default = true;};

    package = mkOption {
      type = types.package;
      default = vicinae;
      defaultText = literalExpression "vicinae";
      description = "The vicinae package to use.";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start the vicinae daemon automatically on login.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    # https://docs.vicinae.com/theming#creating-a-custom-theme
    home.file.".config/vicinae/themes/custom.json" = {
      text = builtins.toJSON {
        version = "1.0.0";
        appearance = "dark";
        icon = "";
        name = "Custom Theme";
        description = "Theme generated from NixOS defaults colorScheme";
        palette = {
          blue = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
          green = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
          magenta = "#${nixosConfig.defaults.colorScheme.palette.base0E}";
          orange = "#${nixosConfig.defaults.colorScheme.palette.base09}";
          purple = "#${nixosConfig.defaults.colorScheme.palette.base0F}";
          red = "#${nixosConfig.defaults.colorScheme.palette.base08}";
          yellow = "#${nixosConfig.defaults.colorScheme.palette.base0A}";
          cyan = "#${nixosConfig.defaults.colorScheme.palette.base0C}";

          background = "#${nixosConfig.defaults.colorScheme.palette.base01}";
          foreground = "#${nixosConfig.defaults.colorScheme.palette.base05}";

          # Text colors
          text = "#${nixosConfig.defaults.colorScheme.palette.base05}";
          subtext = "#${nixosConfig.defaults.colorScheme.palette.base04}";
          textTertiary = "#${nixosConfig.defaults.colorScheme.palette.base03}";
          textDisabled = "#${nixosConfig.defaults.colorScheme.palette.base03}";
          textOnAccent = "#${nixosConfig.defaults.colorScheme.palette.base00}";
          textError = "#${nixosConfig.defaults.colorScheme.palette.base08}";
          textSuccess = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
          textWarning = "#${nixosConfig.defaults.colorScheme.palette.base0A}";

          # Background colors
          mainBackground = "#${nixosConfig.defaults.colorScheme.palette.base01}";
          mainSelectedBackground = "#${nixosConfig.defaults.colorScheme.palette.base02}";
          mainHoveredBackground = "#${nixosConfig.defaults.colorScheme.palette.base02}";
          secondaryBackground = "#${nixosConfig.defaults.colorScheme.palette.base00}";
          tertiaryBackground = "#${nixosConfig.defaults.colorScheme.palette.base00}";
          statusBackground = "#${nixosConfig.defaults.colorScheme.palette.base01}";
          statusBackgroundBorder = "#${nixosConfig.defaults.colorScheme.palette.base02}";
          statusBackgroundHover = "#${nixosConfig.defaults.colorScheme.palette.base02}";
          statusBackgroundLighter = "#${nixosConfig.defaults.colorScheme.palette.base00}";

          # Button colors
          buttonPrimary = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
          buttonPrimaryHover = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
          buttonPrimaryPressed = "#${nixosConfig.defaults.colorScheme.palette.base0E}";
          buttonPrimaryDisabled = "#${nixosConfig.defaults.colorScheme.palette.base03}";
          buttonSecondary = "#${nixosConfig.defaults.colorScheme.palette.base02}";
          buttonSecondaryHover = "#${nixosConfig.defaults.colorScheme.palette.base01}";
          buttonSecondaryPressed = "#${nixosConfig.defaults.colorScheme.palette.base00}";
          buttonSecondaryDisabled = "#${nixosConfig.defaults.colorScheme.palette.base03}";
          buttonDestructive = "#${nixosConfig.defaults.colorScheme.palette.base08}";
          buttonDestructiveHover = "#${nixosConfig.defaults.colorScheme.palette.base08}";
          buttonDestructivePressed = "#${nixosConfig.defaults.colorScheme.palette.base09}";

          # Input colors
          inputBackground = "#${nixosConfig.defaults.colorScheme.palette.base00}";
          inputBorder = "#${nixosConfig.defaults.colorScheme.palette.base02}";
          inputBorderFocus = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
          inputBorderError = "#${nixosConfig.defaults.colorScheme.palette.base08}";
          inputPlaceholder = "#${nixosConfig.defaults.colorScheme.palette.base03}";

          # Border colors
          border = "#${nixosConfig.defaults.colorScheme.palette.base02}";
          borderSubtle = "#${nixosConfig.defaults.colorScheme.palette.base01}";
          borderStrong = "#${nixosConfig.defaults.colorScheme.palette.base02}";
          separator = "#${nixosConfig.defaults.colorScheme.palette.base02}";
          shadow = "#${nixosConfig.defaults.colorScheme.palette.base00}";

          # State colors
          errorBackground = "#${nixosConfig.defaults.colorScheme.palette.base08}";
          errorBorder = "#${nixosConfig.defaults.colorScheme.palette.base08}";
          successBackground = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
          successBorder = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
          warningBackground = "#${nixosConfig.defaults.colorScheme.palette.base0A}";
          warningBorder = "#${nixosConfig.defaults.colorScheme.palette.base0A}";

          # Link colors
          linkDefault = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
          linkHover = "#${nixosConfig.defaults.colorScheme.palette.base0C}";
          linkVisited = "#${nixosConfig.defaults.colorScheme.palette.base0F}";

          # Focus and overlay colors
          focus = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
          overlay = "#${nixosConfig.defaults.colorScheme.palette.base00}";
          tooltip = "#${nixosConfig.defaults.colorScheme.palette.base01}";
          tooltipText = "#${nixosConfig.defaults.colorScheme.palette.base05}";
        };
      };
    };

    systemd.user.services.vicinae = {
      Unit = {
        Description = "Vicinae launcher daemon";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/vicinae server";
        Restart = "on-failure";
        RestartSec = 3;
      };

      Install = mkIf cfg.autoStart {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
