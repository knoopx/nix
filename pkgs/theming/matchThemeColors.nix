{
  pkgs,
  defaults,
  lib,
  ...
}: let
  script = pkgs.writeTextFile {
    name = "match-theme-colors.rb";
    text = ''
      def hex_to_rgb(hex)
        hex.match(/^#(..)(..)(..)$/).captures.map { |component| component.to_i(16) }
      end

      def color_distance(c1, c2)
        Math.sqrt((c1[0] - c2[0]) ** 2 + (c1[1] - c2[1]) ** 2 + (c1[2] - c2[2]) ** 2)
      end

      TARGET_COLORS = [
        ${lib.concatStringsSep "," (lib.map (x: "#${x}") (lib.attrValues defaults.colorScheme.palette))}
      ]

      def closest_color(hex_color)
        rgb_color = hex_to_rgb(hex_color)
        TARGET_COLORS.min_by { |target| color_distance(rgb_color, hex_to_rgb(target)) }
      end

      puts File.open(ARGV.first, "rb").read.gsub(/#[0-9a-fA-F]{6}/) { |m| closest_color(m) }
    '';
  };
in
  pkgs.writeShellApplication {
    name = "match-theme-colors";
    text = ''
      ${lib.getExe pkgs.ruby} ${script} "$@"
    '';
  }
