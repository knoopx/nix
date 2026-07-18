{ pkgs
, lib
, config
, ...
} @ inputs:
let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
  system = "x86_64-linux";
in
{
  imports =
    [
      ./boot.nix
      ./hardware.nix
      ./services.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  # Use julianjc84's niri fork (feat/configurable-touch-gestures) for
  # configurable touchscreen and touchpad gesture support.
  nixpkgs.overlays = [
    (final: prev: {
      niri = inputs.niri-touch.packages.${system}.niri.overrideAttrs {
        doCheck = false;
      };
    })
  ];

  system.stateVersion = "25.11";

  networking.hostName = "hi10max";

  services.iio-niri = {
    enable = true;
    extraArgs = [ "--monitor" "eDP-1" ];
  };

  hardware.sensor.iio.enable = true;

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  defaults.wifi = lib.mkForce true;
  defaults.bluetooth = lib.mkForce true;
  defaults.display.width = lib.mkForce 1920;
  defaults.display.height = lib.mkForce 1200;
  defaults.display.idleTimeout = lib.mkForce (15 * 60);
  defaults.display.idleTimeoutAC = lib.mkForce (15 * 60);
  defaults.display.defaultColumnWidthPercent = lib.mkForce 1.0;
  defaults.display.columnWidthPercentPresets = lib.mkForce [ 0.5 0.75 ];
  defaults.display.windowRules = lib.mkForce [
    {
      excludes = [
        { app-id = "scrcpy"; }
        { app-id = "org.gnome.Nautilus"; }
        { app-id = "org.gnome.NautilusPreviewer"; }
        { app-id = "io.bassi.Amberol"; }
        { app-id = "plexamp"; }
        { title = "[Ll]ogin"; }
        { title = "Photos"; }
        { title = "[Ss]ign-?in"; }
        { title = "[Pp]assword"; }
        { title = "Calendar"; }
        { title = "Meet"; }
        { title = "Notion"; }
        { title = "Slack"; }
        { title = "Reddit"; }
        { title = "Telegram"; }
        { title = "Discord"; }
        { title = "WhatsApp"; }
        { title = "Vicinae Launcher"; }
        { title = "Gmail"; }
        { title = "/dev/video0"; }
      ];
      open-fullscreen = true;
    }
    {
      draw-border-with-background = false;
      geometry-corner-radius = {
        top-left = 8.0;
        top-right = 8.0;
        bottom-left = 8.0;
        bottom-right = 8.0;
      };
      clip-to-geometry = true;
    }
    {
      matches = [{ is-floating = true; }];
      geometry-corner-radius = {
        top-left = 16.0;
        top-right = 16.0;
        bottom-left = 16.0;
        bottom-right = 16.0;
      };
    }
    {
      matches = [{ app-id = "scrcpy"; }];
      open-floating = false;
      default-column-width.fixed = 472;
      geometry-corner-radius = {
        top-left = 18.0;
        top-right = 18.0;
        bottom-left = 18.0;
        bottom-right = 18.0;
      };
    }
    {
      matches = [{ app-id = "org.gnome.NautilusPreviewer"; }];
      open-floating = true;
      default-window-height.proportion = 0.75;
    }
    {
      matches = [
        { app-id = "io.bassi.Amberol"; }
        { app-id = "plexamp"; }
      ];
      default-column-width.proportion = 0.25;
    }
    {
      matches = [{ title = "/dev/video0"; }];
      default-column-width.fixed = 400;
      default-window-height.fixed = 300;
      open-floating = true;
      open-focused = false;
      default-floating-position = {
        x = 12;
        y = 12;
        relative-to = "bottom-right";
      };
    }
    {
      matches = [
        { app-id = "scrcpy"; }
        { title = "[Ll]ogin"; }
        { title = "Photos"; }
        { title = "[Ss]ign-?in"; }
        { title = "[Pp]assword"; }
        { title = "Calendar"; }
        { title = "Meet"; }
        { title = "Notion"; }
        { title = "Slack"; }
        { title = "Reddit"; }
        { title = "Telegram"; }
        { title = "Discord"; }
        { title = "WhatsApp"; }
        { title = "Vicinae Launcher"; }
        { title = "Gmail"; }
        { app-id = "org.gnome.Nautilus"; }
      ];
      block-out-from = "screen-capture";
    }
    {
      matches = [{ is-active = false; }];
      opacity = 0.9;
    }
    {
      matches = [{ is-floating = true; }];
      opacity = 1.0;
    }
  ];

  home-manager.users.${config.defaults.username} = {
    imports = [
      ../../home/${config.defaults.username}.nix
    ];

    programs.vicinae.settings.launcher_window.layer_shell = lib.mkForce {
      enabled = true;
      layer = "overlay";
      keyboard_interactivity = "exclusive";
    };

    programs.niri.config = let
      bgColor = config.defaults.colorScheme.palette.base02;
      activeColor = config.defaults.colorScheme.palette.base0D;
      borderColor = config.defaults.colorScheme.palette.base03;
      insertHintRGB = inputs.nix-colors.lib-core.conversions.hexToRGBString " " activeColor;
      xwaylandPath = lib.getExe pkgs.xwayland-satellite;
      gvfsPath = "${config.services.gvfs.package}/lib/gio/modules";
      keyMap = config.defaults.keyMap;
    in ''
      input {
          keyboard {
              xkb { layout "${keyMap}"; }
              repeat-delay 600
              repeat-rate 25
              track-layout "global"
          }
          touchpad {
              tap
              dwt
              natural-scroll
              accel-speed 0.2
              accel-profile "adaptive"
              scroll-factor 0.3
          }
          mouse { accel-speed 0.0; }
          trackpoint { accel-speed 0.0; }
          trackball { accel-speed 0.0; }
          tablet { map-to-output "eDP-1"; }
          touchscreen { map-to-output "eDP-1"; }
          warp-mouse-to-focus
          workspace-auto-back-and-forth
      }
      output "eDP-1" {
          background-color "#${bgColor}"
          scale 1.5
          transform "270"
      }
      screenshot-path "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png"
      prefer-no-csd
      overview {
          zoom 0.7
          backdrop-color "#${bgColor}"
          workspace-shadow { off; }
      }
      layout {
          gaps 12
          background-color "transparent"
          struts { left 0; right 0; top 0; bottom 0; }
          focus-ring {
              width 3
              active-color "#${activeColor}"
          }
          border {
              width 3
              active-color "#${borderColor}"
              inactive-color "#${borderColor}"
          }
          insert-hint { color "rgb(${insertHintRGB} / 50%)"; }
          default-column-width { proportion 1.0; }
          preset-column-widths {
              proportion 0.5
              proportion 0.75
          }
          center-focused-column "never"
      }
      cursor {
          xcursor-theme "default"
          xcursor-size 24
          hide-when-typing
      }
      hotkey-overlay { skip-at-startup; }
      environment { "GIO_EXTRA_MODULES" "${gvfsPath}"; }
      binds {
          "Mod+Period" { toggle-overview; }
          "MouseForward" { toggle-overview; }
          "Mod+J" { spawn "browser"; }
          "Mod+Shift+J" { spawn "file-manager"; }
          "Mod+K" { spawn "pick-project" "editor"; }
          "Mod+Shift+K" { spawn "pi-project"; }
          "Mod+O" { spawn "pick-document" "editor"; }
          "Mod+L" { spawn "terminal"; }
          "Mod+Shift+L" { spawn "pick-project" "terminal"; }
          "Mod+Left" { focus-column-left; }
          "Mod+Right" { focus-column-right; }
          "Mod+Down" { focus-workspace-down; }
          "Mod+Up" { focus-workspace-up; }
          "Mod+D" { focus-window-down-or-top; }
          "Mod+H" { spawn "voice-input-control" "toggle"; }
          "Mod+V" { center-window; }
          "Mod+F" { maximize-column; }
          "Mod+Shift+F" { spawn "window-control" "fullscreen"; }
          "Mod+U" { consume-or-expel-window-left; }
          "Mod+I" { consume-or-expel-window-right; }
          "Mod+Q" { close-window; }
          "Mod+R" { switch-preset-column-width; }
          "Mod+Return" { spawn "window-control" "float-to-corner"; }
          "Mod+Tab" { focus-monitor-next; }
          "Mod+Shift+Tab" { switch-focus-between-floating-and-tiling; }
          "Mod+Shift+Ctrl+L" { quit skip-confirmation=true; }
          "Mod+Shift+Down" { move-column-to-workspace-down; }
          "Mod+Shift+End" { move-workspace-down; }
          "Mod+Shift+Home" { move-workspace-up; }
          "Mod+Shift+Left" { move-column-left; }
          "Mod+Shift+Right" { move-column-right; }
          "Mod+Shift+Up" { move-column-to-workspace-up; }
          "Ctrl+Mod+Shift+Left" { move-window-to-monitor-left; }
          "Ctrl+Mod+Shift+Right" { move-window-to-monitor-right; }
          "Mod+Space" { spawn "vicinae" "toggle"; }
          "Mod+B" { spawn "xdg-open" "vicinae://extensions/vicinae/manage-shortcuts/manage"; }
          "Mod+W" { close-window; }
          "Print" { spawn "niri" "msg" "action" "screenshot" "--show-pointer" "false"; }
          "Shift+Print" { screenshot-window; }
          "Mod+Shift+P" { spawn "window-control" "webcam"; }
          "Mod+P" { spawn "kitty" "sh" "-c" "cd ~/.assistant && pi"; }
          "Mod+Shift+Print" { spawn "screen-recording"; }
          "Ctrl+Mod+Shift+Print" { spawn "screen-recording" "--mode" "portal"; }
          "Mod+G" { spawn "wl-kbptr" "-o" "modes=floating,click" "-o" "mode_floating.source=detect"; }
          "XF86AudioLowerVolume" { spawn "volume-control" "down"; }
          "XF86AudioMute" { spawn "volume-control" "mute"; }
          "XF86AudioNext" { spawn "media-control" "next"; }
          "XF86AudioPlay" { spawn "media-control" "play-pause"; }
          "XF86AudioPrev" { spawn "media-control" "previous"; }
          "XF86AudioRaiseVolume" { spawn "volume-control" "up"; }
          "XF86AudioStop" { spawn "media-control" "stop"; }
          "XF86MonBrightnessDown" { spawn "brightness-control" "down"; }
          "XF86MonBrightnessUp" { spawn "brightness-control" "up"; }
      }
      switch-events {
          lid-close { spawn "display-control" "power-off-monitors"; }
          tablet-mode-off { spawn "tablet-mode-control" "off"; }
          tablet-mode-on { spawn "tablet-mode-control" "on"; }
      }
      window-rule {
          exclude app-id="scrcpy"
          exclude app-id="org.gnome.Nautilus"
          exclude app-id="org.gnome.NautilusPreviewer"
          exclude app-id="io.bassi.Amberol"
          exclude app-id="plexamp"
          exclude title="[Ll]ogin"
          exclude title="Photos"
          exclude title="[Ss]ign-?in"
          exclude title="[Pp]assword"
          exclude title="Calendar"
          exclude title="Meet"
          exclude title="Notion"
          exclude title="Slack"
          exclude title="Reddit"
          exclude title="Telegram"
          exclude title="Discord"
          exclude title="WhatsApp"
          exclude title="Vicinae Launcher"
          exclude title="Gmail"
          exclude title="/dev/video0"
          open-fullscreen true
      }
      window-rule {
          draw-border-with-background false
          geometry-corner-radius 8 8 8 8
          clip-to-geometry true
      }
      window-rule {
          match is-floating=true
          geometry-corner-radius 16 16 16 16
      }
      window-rule {
          match app-id="scrcpy"
          default-column-width { fixed 472; }
          open-floating false
          geometry-corner-radius 18 18 18 18
      }
      window-rule {
          match app-id="org.gnome.NautilusPreviewer"
          default-window-height { proportion 0.75; }
          open-floating true
      }
      window-rule {
          match app-id="io.bassi.Amberol"
          match app-id="plexamp"
          default-column-width { proportion 0.25; }
      }
      window-rule {
          match title="/dev/video0"
          default-column-width { fixed 400; }
          default-window-height { fixed 300; }
          open-floating true
          open-focused false
          default-floating-position relative-to="bottom-right" x=12 y=12
      }
      window-rule {
          match app-id="scrcpy"
          match title="[Ll]ogin"
          match title="Photos"
          match title="[Ss]ign-?in"
          match title="[Pp]assword"
          match title="Calendar"
          match title="Meet"
          match title="Notion"
          match title="Slack"
          match title="Reddit"
          match title="Telegram"
          match title="Discord"
          match title="WhatsApp"
          match title="Vicinae Launcher"
          match title="Gmail"
          match app-id="org.gnome.Nautilus"
          block-out-from "screen-capture"
      }
      window-rule {
          match is-active=false
          opacity 0.9
      }
      window-rule {
          match is-floating=true
          opacity 1.0
      }
      layer-rule {
          match namespace="notifications"
          block-out-from "screen-capture"
      }
      layer-rule {
          match namespace="^wallpaper$"
          place-within-backdrop true
      }
      gestures { hot-corners { off; }; }
      animations {
          slowdown 0.6
          window-open {
              duration-ms 750
              curve "ease-out-cubic"
          }
          window-close {
              duration-ms 750
              curve "ease-out-cubic"
          }
      }
      xwayland-satellite { path "${xwaylandPath}"; }

      // niri-touch-config gesture includes (julianjc84's fork)
      include "touchscreen-gestures.kdl" optional=true
      include "touchpad-gestures.kdl"    optional=true
    '';

    # Gesture KDL files for julianjc84's niri fork (feat/configurable-touch-gestures).
    # Included via `include` directives in config.kdl above.
    xdg.configFile = {
      "niri/touchscreen-gestures.kdl".text = builtins.readFile ./touchscreen-gestures.kdl;
      "niri/touchpad-gestures.kdl".text = builtins.readFile ./touchpad-gestures.kdl;
    };
  };
}
