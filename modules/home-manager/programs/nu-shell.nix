{
  pkgs,
  nixosConfig,
  ...
}: let
  colors = nixosConfig.defaults.colorScheme.palette;
  carapace_nu = pkgs.runCommandLocal "carapace.nu" {buildInputs = [pkgs.carapace];} ''
    carapace _carapace nushell >$out
  '';
in {
  programs.nushell = {
    enable = true;
    configFile = {
      text = ''
        $env.config.show_banner = false
        $env.config = {
          color_config: {
            separator: "#${colors.base03}"
            leading_trailing_space_bg: "#${colors.base04}"
            header: "#${colors.base0B}"
            datetime: "#${colors.base0E}"
            filesize: "#${colors.base0D}"
            row_index: "#${colors.base0C}"
            bool: "#${colors.base08}"
            int: "#${colors.base0B}"
            duration: "#${colors.base08}"
            range: "#${colors.base08}"
            float: "#${colors.base08}"
            string: "#${colors.base04}"
            nothing: "#${colors.base08}"
            binary: "#${colors.base08}"
            cellpath: "#${colors.base08}"
            hints: "dark_gray"
            shape_garbage: { fg: "#${colors.base05}" bg: "#${colors.base08}" attr: "b" }
            shape_bool: "#${colors.base0D}"
            shape_int: { fg: "#${colors.base0E}" attr: "b" }
            shape_float: { fg: "#${colors.base0E}" attr: "b" }
            shape_range: { fg: "#${colors.base0A}" attr: "b" }
            shape_internalcall: { fg: "#${colors.base0C}" attr: "b" }
            shape_external: "#${colors.base0C}"
            shape_externalarg: { fg: "#${colors.base0B}" attr: "b" }
            shape_literal: "#${colors.base0D}"
            shape_operator: "#${colors.base0A}"
            shape_signature: { fg: "#${colors.base0B}" attr: "b" }
            shape_string: "#${colors.base0B}"
            shape_filepath: "#${colors.base0D}"
            shape_globpattern: { fg: "#${colors.base0D}" attr: "b" }
            shape_variable: "#${colors.base0E}"
            shape_flag: { fg: "#${colors.base0D}" attr: "b" }
            shape_custom: { attr: "b" }
          }
        }
      '';
    };
    envFile = {
      text = ''
        source ${carapace_nu}
        $env.INTELLI_VARIABLE_HOTKEY = "control char_k"

        export def git-branches []: nothing -> list<record<ref: string, obj: string, upstream: string, subject: string>> {
          ^git for-each-ref --format '%(refname:lstrip=2)%09%(objectname:short)%09%(upstream:remotename)%(upstream:track)%09%(contents:subject)' refs/heads | lines | parse "{ref}\t{obj}\t{upstream}\t{subject}"
        }

        export def git-remote-branches []: nothing -> list<record<ref: string, obj: string, subject: string>> {
          ^git for-each-ref --format '%(refname:lstrip=2)%09%(objectname:short)%09%(contents:subject)' refs/remotes | lines | parse "{ref}\t{obj}\t{subject}"
        }
      '';
    };
  };
}
