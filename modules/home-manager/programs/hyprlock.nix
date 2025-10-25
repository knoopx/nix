{
  pkgs,
  nixosConfig,
  lib,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };

      bind = [
        "XF86AudioRaiseVolume,exec,volume-control up"
        "XF86AudioLowerVolume,exec,volume-control down"
        "XF86AudioMute,exec,volume-control mute"
      ];

      background = lib.mkForce [
        {
          monitor = "";
          color = "rgba(${nixosConfig.defaults.colorScheme.palette.base00}ff)";
        }
      ];

      input-field = lib.mkForce [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 3;
          outer_color = "rgba(${nixosConfig.defaults.colorScheme.palette.base0D}ff)";
          inner_color = "rgba(${nixosConfig.defaults.colorScheme.palette.base00}ff)";
          font_color = "rgba(${nixosConfig.defaults.colorScheme.palette.base05}ff)";
          fail_color = "rgba(${nixosConfig.defaults.colorScheme.palette.base08}ff)";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_transition = 0;
          fade_on_empty = false;
          placeholder_text = "Password...";
          dots_size = 0.2;
          dots_spacing = 0.64;
          dots_center = true;
          position = "0, 140";
          halign = "center";
          valign = "bottom";
        }
      ];

      label = lib.mkForce [
        {
          monitor = "";
          text = "$TIME";
          font_size = nixosConfig.defaults.fonts.baseSize * 6;
          font_family = "${nixosConfig.defaults.fonts.sansSerif.name} ${toString nixosConfig.defaults.fonts.baseSize}";
          color = "rgba(${nixosConfig.defaults.colorScheme.palette.base05}ff)";
          position = "0, 16";
          valign = "center";
          halign = "center";
        }
        {
          monitor = "";
          text = "$USER";
          color = "rgba(${nixosConfig.defaults.colorScheme.palette.base05}ff)";
          font_size = nixosConfig.defaults.fonts.baseSize * 2;
          font_family = "${nixosConfig.defaults.fonts.sansSerif.name} ${toString nixosConfig.defaults.fonts.baseSize}";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Current Layout : $LAYOUT";
          color = "rgba(${nixosConfig.defaults.colorScheme.palette.base05}ff)";
          font_size = nixosConfig.defaults.fonts.baseSize;
          font_family = "${nixosConfig.defaults.fonts.sansSerif.name} ${toString nixosConfig.defaults.fonts.baseSize}";
          position = "0, 20";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
