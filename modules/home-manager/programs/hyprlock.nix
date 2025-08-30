{
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
          outer_color = "rgba(${nixosConfig.defaults.colorScheme.palette.base0E}ff)";
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
          font_size = nixosConfig.defaults.fonts.sizes.applications * 6;
          font_family = "${nixosConfig.defaults.fonts.monospace.name} ${toString nixosConfig.defaults.fonts.sizes.applications}";
          color = "rgba(${nixosConfig.defaults.colorScheme.palette.base05}ff)";
          position = "0, 16";
          valign = "center";
          halign = "center";
        }
        {
          monitor = "";
          text = "Hello <span text_transform=\"capitalize\" size=\"larger\">$USER!</span>";
          color = "rgba(${nixosConfig.defaults.colorScheme.palette.base05}ff)";
          font_size = nixosConfig.defaults.fonts.sizes.applications * 2;
          font_family = "${nixosConfig.defaults.fonts.monospace.name} ${toString nixosConfig.defaults.fonts.sizes.applications}";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Current Layout : $LAYOUT";
          color = "rgba(${nixosConfig.defaults.colorScheme.palette.base05}ff)";
          font_size = nixosConfig.defaults.fonts.sizes.applications;
          font_family = "${nixosConfig.defaults.fonts.monospace.name} ${toString nixosConfig.defaults.fonts.sizes.applications}";
          position = "0, 20";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
