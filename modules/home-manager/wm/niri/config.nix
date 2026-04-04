{
  lib,
  pkgs,
  nixosConfig,
  nix-colors,
  ...
}: {
  services.gnome-keyring.enable = true;
  home.packages = [
    pkgs.playerctl
    pkgs.wireplumber
    pkgs.xwayland-satellite
    pkgs.screen-recording
    pkgs.recording-indicator
    pkgs.voice-input-control
    pkgs.pi-project
    pkgs.pick-project
  ];

  programs.niri = {
    settings = {
      input = {
        keyboard = {
          xkb.layout = nixosConfig.defaults.keyMap;
          repeat-delay = 600;
          repeat-rate = 25;
          track-layout = "global";
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
          dwt = true;
          click-method = "clickfinger";
          accel-speed = 0.0;
        };

        mouse.accel-speed = 0.0;
        trackpoint.accel-speed = 0.0;
        trackball.accel-speed = 0.0;

        warp-mouse-to-focus.enable = true;
        workspace-auto-back-and-forth = true;
      };

      gestures = {
        hot-corners.enable = false;
      };

      screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png";

      prefer-no-csd = true;

      overview = {
        backdrop-color = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        workspace-shadow.enable = false;
        zoom = 0.7;
      };

      layout = {
        gaps = 12;
        background-color = "transparent";
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
        focus-ring = {
          enable = true;
          width = 3;
          active.color = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        };
        border = {
          width = 3;
          active.color = "#${nixosConfig.defaults.colorScheme.palette.base03}";
          inactive.color = "#${nixosConfig.defaults.colorScheme.palette.base03}";
        };
        insert-hint.display.color = "rgb(${nix-colors.lib-core.conversions.hexToRGBString " " nixosConfig.defaults.colorScheme.palette.base0D} / 50%)";

        default-column-width.proportion = nixosConfig.defaults.display.defaultColumnWidthPercent;
        preset-column-widths = map (width: {proportion = width;}) nixosConfig.defaults.display.columnWidthPercentPresets;
        center-focused-column = "on-overflow";
        always-center-single-column = true;
      };

      cursor = {
        theme = "default";
        size = 24;
        hide-when-typing = true;
      };

      hotkey-overlay.skip-at-startup = true;

      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };

      environment = {
        GIO_EXTRA_MODULES = "${nixosConfig.services.gvfs.package}/lib/gio/modules";
      };

      binds = {
        "Mod+Period".action = {"toggle-overview" = [];}; # used with keyd
        "MouseForward".action = {toggle-overview = [];};

        "Mod+J".action = {spawn = ["browser"];};
        "Mod+Shift+J".action = {spawn = ["file-manager"];};
        "Mod+K".action = {spawn = ["pick-project" "editor"];};
        "Mod+Shift+K".action = {spawn = ["pi-project"];};
        "Mod+O".action = {spawn = ["pick-document" "editor"];};
        "Mod+L".action = {spawn = ["terminal"];};
        "Mod+Shift+L".action = {spawn = ["pick-project" "terminal"];};

        "Mod+Left".action = {"focus-column-left" = [];};
        "Mod+Right".action = {"focus-column-right" = [];};
        "Mod+Down".action = {"focus-workspace-down" = [];};
        "Mod+Up".action = {"focus-workspace-up" = [];};

        "Mod+D".action = {"focus-window-down-or-top" = [];};
        "Mod+H".action = {spawn = ["voice-input-control" "toggle"];};
        "Mod+V".action = {"center-window" = [];};
        "Mod+F".action = {"maximize-column" = [];};
        "Mod+Shift+F".action = {spawn = ["window-control" "fullscreen"];};

        "Mod+U".action = {"consume-or-expel-window-left" = [];};
        "Mod+I".action = {"consume-or-expel-window-right" = [];};

        "Mod+Q".action = {"close-window" = [];};
        "Mod+R".action = {"switch-preset-column-width" = [];};
        "Mod+Return".action = {spawn = ["window-control" "float-to-corner"];};
        "Mod+Tab".action = {"focus-monitor-next" = [];};
        "Mod+Shift+Tab".action = {"switch-focus-between-floating-and-tiling" = [];};
        "Mod+Shift+Ctrl+L".action = {quit = {"skip-confirmation" = true;};};
        "Mod+Shift+Down".action = {"move-column-to-workspace-down" = [];};
        "Mod+Shift+End".action = {"move-workspace-down" = [];};
        "Mod+Shift+Home".action = {"move-workspace-up" = [];};
        "Mod+Shift+Left".action = {"move-column-left" = [];};
        "Mod+Shift+Right".action = {"move-column-right" = [];};

        "Ctrl+Mod+Shift+Left".action = {"move-window-to-monitor-left" = [];};
        "Ctrl+Mod+Shift+Right".action = {"move-window-to-monitor-right" = [];};

        "Mod+Shift+Up".action = {"move-column-to-workspace-up" = [];};
        "Mod+Space".action = {spawn = ["vicinae" "toggle"];};
        "Mod+B".action = {spawn = ["xdg-open" "vicinae://extensions/vicinae/manage-shortcuts/manage"];};
        "Mod+P".action = {spawn = ["xdg-open" "vicinae://extensions/leonkohli/process-manager/processes"];};
        "Mod+W".action = {"close-window" = [];};
        "Print".action.spawn = ["niri" "msg" "action" "screenshot" "--show-pointer" "false"];
        "Shift+Print".action = {"screenshot-window" = [];};
        "Mod+Shift+P".action = {spawn = ["window-control" "webcam"];};
        "Mod+Shift+Print".action = {spawn = ["screen-recording"];};
        "Mod+G".action = {spawn = ["wl-kbptr" "-o" "modes=floating,click" "-o" "mode_floating.source=detect"];};
        "XF86AudioLowerVolume".action = {spawn = ["volume-control" "down"];};
        "XF86AudioMute".action = {spawn = ["volume-control" "mute"];};
        "XF86AudioNext".action = {spawn = ["media-control" "next"];};
        "XF86AudioPlay".action = {spawn = ["media-control" "play-pause"];};
        "XF86AudioPrev".action = {spawn = ["media-control" "previous"];};
        "XF86AudioRaiseVolume".action = {spawn = ["volume-control" "up"];};
        "XF86AudioStop".action = {spawn = ["media-control" "stop"];};
        "XF86MonBrightnessDown".action = {spawn = ["brightness-control" "down"];};
        "XF86MonBrightnessUp".action = {spawn = ["brightness-control" "up"];};
      };

      switch-events = {
        lid-close.action = {spawn = ["display-control" "power-off-monitors"];};
        tablet-mode-on.action = {spawn = ["tablet-mode-control" "on"];};
        tablet-mode-off.action = {spawn = ["tablet-mode-control" "off"];};
      };

      window-rules = nixosConfig.defaults.display.windowRules;
      layer-rules = nixosConfig.defaults.display.layerRules;

      animations = {
        slowdown = 0.6;
        window-open = {
          kind = {
            easing = {
              duration-ms = 750;
              curve = "ease-out-cubic";
            };
          };
          custom-shader = ''
            float gh(float n) {
                return fract(sin(n) * 43758.5453);
            }

            vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                float p = niri_clamped_progress;
                vec2 uv = coords_geo.xy;

                float intensity = (1.0 - p) * (1.0 - p);

                float tick = floor(p * 60.0) + niri_random_seed * 1000.0;
                float r1 = gh(tick * 1.13);
                float r2 = gh(tick * 2.37);
                float r3 = gh(tick * 3.71);
                float r4 = gh(tick * 4.19);
                float r5 = gh(tick * 5.53);
                float r6 = gh(tick * 6.91);

                vec2 off_r = vec2(r1 - 0.5, r2 - 0.5) * intensity * 0.12;
                vec2 off_g = vec2(r3 - 0.5, r4 - 0.5) * intensity * 0.12;
                vec2 off_b = vec2(r5 - 0.5, r6 - 0.5) * intensity * 0.12;

                float slice = floor(uv.y * 20.0);
                float slice_offset = (gh(slice + tick) - 0.5) * intensity * 0.08;

                vec2 uv_r = uv + off_r + vec2(slice_offset * 0.7, 0.0);
                vec2 uv_g = uv + off_g + vec2(slice_offset * -0.5, 0.0);
                vec2 uv_b = uv + off_b + vec2(slice_offset * 0.3, 0.0);

                vec3 tc_r = niri_geo_to_tex * vec3(uv_r, 1.0);
                vec3 tc_g = niri_geo_to_tex * vec3(uv_g, 1.0);
                vec3 tc_b = niri_geo_to_tex * vec3(uv_b, 1.0);

                vec4 color;
                color.r = texture2D(niri_tex, tc_r.st).r;
                color.g = texture2D(niri_tex, tc_g.st).g;
                color.b = texture2D(niri_tex, tc_b.st).b;
                color.a = max(max(
                    texture2D(niri_tex, tc_r.st).a,
                    texture2D(niri_tex, tc_g.st).a),
                    texture2D(niri_tex, tc_b.st).a);

                float big_glitch = step(0.85, gh(tick * 0.77));
                vec2 shift = vec2((gh(tick * 1.5) - 0.5) * 0.06 * big_glitch * intensity, 0.0);
                vec3 tc_shift = niri_geo_to_tex * vec3(uv + shift, 1.0);
                vec4 shifted = texture2D(niri_tex, tc_shift.st);
                color = mix(color, shifted, big_glitch * intensity * 0.4);

                float scanline = 1.0 - sin(uv.y * size_geo.y * 3.14159) * 0.06 * intensity;
                color.rgb *= scanline;

                float alpha = smoothstep(0.0, 0.15, p);
                return color * alpha;
            }
          '';
        };
        window-close = {
          kind = {
            easing = {
              duration-ms = 750;
              curve = "ease-out-cubic";
            };
          };
          custom-shader = ''
            float gh(float n) {
                return fract(sin(n) * 43758.5453);
            }

            vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                float p = niri_clamped_progress;
                vec2 uv = coords_geo.xy;

                float intensity = p * p;

                float tick = floor(p * 60.0) + niri_random_seed * 1000.0;
                float r1 = gh(tick * 1.13);
                float r2 = gh(tick * 2.37);
                float r3 = gh(tick * 3.71);
                float r4 = gh(tick * 4.19);
                float r5 = gh(tick * 5.53);
                float r6 = gh(tick * 6.91);

                vec2 off_r = vec2(r1 - 0.5, r2 - 0.5) * intensity * 0.15;
                vec2 off_g = vec2(r3 - 0.5, r4 - 0.5) * intensity * 0.15;
                vec2 off_b = vec2(r5 - 0.5, r6 - 0.5) * intensity * 0.15;

                float slice = floor(uv.y * 20.0);
                float slice_offset = (gh(slice + tick) - 0.5) * intensity * 0.12;

                vec2 uv_r = uv + off_r + vec2(slice_offset * 0.7, 0.0);
                vec2 uv_g = uv + off_g + vec2(slice_offset * -0.5, 0.0);
                vec2 uv_b = uv + off_b + vec2(slice_offset * 0.3, 0.0);

                vec3 tc_r = niri_geo_to_tex * vec3(uv_r, 1.0);
                vec3 tc_g = niri_geo_to_tex * vec3(uv_g, 1.0);
                vec3 tc_b = niri_geo_to_tex * vec3(uv_b, 1.0);

                vec4 color;
                color.r = texture2D(niri_tex, tc_r.st).r;
                color.g = texture2D(niri_tex, tc_g.st).g;
                color.b = texture2D(niri_tex, tc_b.st).b;
                color.a = max(max(
                    texture2D(niri_tex, tc_r.st).a,
                    texture2D(niri_tex, tc_g.st).a),
                    texture2D(niri_tex, tc_b.st).a);

                float big_glitch = step(0.8 - p * 0.3, gh(tick * 0.77));
                vec2 shift = vec2((gh(tick * 1.5) - 0.5) * 0.08 * big_glitch * intensity, 0.0);
                vec3 tc_shift = niri_geo_to_tex * vec3(uv + shift, 1.0);
                vec4 shifted = texture2D(niri_tex, tc_shift.st);
                color = mix(color, shifted, big_glitch * intensity * 0.5);

                float scanline = 1.0 - sin(uv.y * size_geo.y * 3.14159) * 0.08 * intensity;
                color.rgb *= scanline;

                float alpha = smoothstep(1.0, 0.6, p);
                return color * alpha;
            }
          '';
        };
      };
    };
  };
}
