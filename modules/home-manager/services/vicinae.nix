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
      owner = "vicinaehq";
      repo = "vicinae";
      rev = "v0.7.0";
      hash = "sha256-tXyP7KJxiLzmm1XrhPnCemg+TEBB8tuTlGyCKiTIdYQ=";
    };

    # Prepare node_modules for api folder
    apiDeps = pkgs.fetchNpmDeps {
      src = src + /api;
      hash = "sha256-7rsaGjs1wMe0zx+/BD1Mx7DQj3IAEZQvdS768jVLl3E=";
    };
    ts-protoc-gen-wrapper = pkgs.writeShellScriptBin "protoc-gen-ts_proto" ''
      exec node /build/source/vicinae-upstream/api/node_modules/.bin/protoc-gen-ts_proto
    '';

    # Prepare node_modules for extension-manager folder
    extensionManagerDeps = pkgs.fetchNpmDeps {
      src = src + /extension-manager;
      hash = "sha256-7kScWi1ySUBTDsGQqgpt2wYmujP9Mlwq3x2FKOlGwgo=";
    };
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
        substituteInPlace cmake/ExtensionApi.cmake cmake/ExtensionManager.cmake --replace "COMMAND npm install" ""
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
          background = "#${nixosConfig.defaults.colorScheme.palette.base01}";
          foreground = "#${nixosConfig.defaults.colorScheme.palette.base05}";
          blue = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
          green = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
          magenta = "#${nixosConfig.defaults.colorScheme.palette.base0E}";
          orange = "#${nixosConfig.defaults.colorScheme.palette.base09}";
          purple = "#${nixosConfig.defaults.colorScheme.palette.base0F}";
          red = "#${nixosConfig.defaults.colorScheme.palette.base08}";
          yellow = "#${nixosConfig.defaults.colorScheme.palette.base0A}";
          cyan = "#${nixosConfig.defaults.colorScheme.palette.base0C}";
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
