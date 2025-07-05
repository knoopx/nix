{pkgs, ...}: let
  rotateScript = direction:
    pkgs.writeShellScript "niri-rotate-display-${direction}" ''
      output=$(niri msg --json outputs | ${pkgs.jq}/bin/jq -r 'to_entries[] | select(.value.logical.transform != "Disabled") | .key' | head -n1)
      niri msg output "$output" transform ${direction}
    '';
in
  pkgs.buildEnv {
    name = "niri-rotate-display-desktop-items";
    paths = [
      (pkgs.makeDesktopItem {
        name = "niri-rotate-normal";
        desktopName = "Rotate Display Untransformed";
        exec = rotateScript "normal";
        icon = "object-rotate-left";
        categories = ["Settings" "Utility"];
      })
      (pkgs.makeDesktopItem {
        name = "niri-rotate-90";
        desktopName = "Rotate Display 90°";
        exec = rotateScript "90";
        icon = "object-rotate-right";
        categories = ["Settings" "Utility"];
      })
      (pkgs.makeDesktopItem {
        name = "niri-rotate-180";
        desktopName = "Rotate Display 180°";
        exec = rotateScript "180";
        icon = "object-flip-vertical";
        categories = ["Settings" "Utility"];
      })
      (pkgs.makeDesktopItem {
        name = "niri-rotate-270";
        desktopName = "Rotate Display 270°";
        exec = rotateScript "270";
        icon = "object-rotate-left";
        categories = ["Settings" "Utility"];
      })
      (pkgs.makeDesktopItem {
        name = "niri-rotate-flipped";
        desktopName = "Flip Display Horizontally";
        exec = rotateScript "flipped";
        icon = "object-flip-horizontal";
        categories = ["Settings" "Utility"];
      })
      (pkgs.makeDesktopItem {
        name = "niri-rotate-flipped-90";
        desktopName = "Rotate Display 90° + Flip Horizontally";
        exec = rotateScript "flipped-90";
        icon = "object-rotate-right";
        categories = ["Settings" "Utility"];
      })
      (pkgs.makeDesktopItem {
        name = "niri-rotate-flipped-180";
        desktopName = "Flip Display Vertically";
        exec = rotateScript "flipped-180";
        icon = "object-flip-vertical";
        categories = ["Settings" "Utility"];
      })
      (pkgs.makeDesktopItem {
        name = "niri-rotate-flipped-270";
        desktopName = "Rotate Display 270° + Flip Horizontally";
        exec = rotateScript "flipped-270";
        icon = "object-rotate-left";
        categories = ["Settings" "Utility"];
      })
    ];
  }
