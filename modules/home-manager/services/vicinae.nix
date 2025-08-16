{
  config,
  nixosConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.vicinae;

  vicinae = pkgs.stdenv.mkDerivation rec {
    pname = "vicinae";
    version = "0.1.0";

    src = pkgs.fetchurl {
      url = "https://github.com/vicinaehq/vicinae/releases/download/v${version}/vicinae-linux-x86_64-v${version}.tar.gz";
      sha256 = "sha256-HYynXER3KUtMbhHJMMtzAICPsWfQXC3ck2gqQX2AQD0=";
    };

    nativeBuildInputs = with pkgs; [autoPatchelfHook qt6.wrapQtAppsHook];
    buildInputs = with pkgs; [
      qt6.qtbase
      qt6.qtsvg
      qt6.qttools
      qt6.qtwayland
      qt6.qtdeclarative
      qt6.qt5compat
      kdePackages.qtkeychain
      kdePackages.layer-shell-qt
      openssl
      cmark-gfm
      libqalculate
      minizip
      stdenv.cc.cc.lib
      abseil-cpp
      protobuf
      nodejs
      wayland
    ];

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      cp bin/vicinae $out/bin/
      cp share/applications/vicinae.desktop $out/share/applications/
      chmod +x $out/bin/vicinae
    '';

    dontWrapQtApps = true;

    preFixup = ''
      wrapQtApp "$out/bin/vicinae" --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
    '';

    meta = {
      description = "A focused launcher for your desktop — native, fast, extensible";
      homepage = "https://github.com/vicinaehq/vicinae";
      license = pkgs.lib.licenses.gpl3;
      maintainers = [];
      platforms = pkgs.lib.platforms.linux;
    };
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
