{ nixosConfig
, pkgs
, ...
}:
let
  colors = nixosConfig.defaults.colorScheme.palette;

  nu_plugin_file = pkgs.rustPlatform.buildRustPackage rec {
    pname = "nu_plugin_file";
    version = "0.22.0";

    src = pkgs.fetchFromGitHub {
      owner = "fdncred";
      repo = "nu_plugin_file";
      rev = "v${version}";
      hash = "sha256-play1lKAboy4bgmlTQ2Cw6OEuxAmGrd5iI2erkGJFK8=";
    };
    cargoHash = "sha256-lGxwrkjQPK054cmMs0livc8g3MBlQex+m1XUBlDxjWs=";
    meta = {
      description = "A nushell plugin to inspect file formats using magic bytes";
      homepage = "https://github.com/fdncred/nu_plugin_file";
      license = with pkgs.lib.licenses; [ agpl3Plus ];
      mainProgram = "nu_plugin_file";
    };
  };

  nu_plugin_toon = pkgs.rustPlatform.buildRustPackage {
    pname = "nu_plugin_toon";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "fdncred";
      repo = "nu_plugin_toon";
      rev = "99dfedc2031ff574babe2d6f94be071cd826c9d4";
      hash = "sha256-0Wls+oE3OyHvh19FNjzfn0EaZlucnhSKTQUlfoIP3gQ=";
    };
    cargoHash = "sha256-ezqMkhzexhPFcUd4xPibaG1Sq+/fFhUWuGvfUAmEkhM=";
    doCheck = false;
    meta = {
      description = "A nushell plugin that implements the toon format";
      homepage = "https://github.com/fdncred/nu_plugin_toon";
      license = with pkgs.lib.licenses; [ mit ];
      mainProgram = "nu_plugin_toon";
    };
  };

  nu_plugin_json_path = pkgs.rustPlatform.buildRustPackage {
    pname = "nu_plugin_json_path";
    version = "0.21.0";

    src = pkgs.fetchFromGitHub {
      owner = "fdncred";
      repo = "nu_plugin_json_path";
      rev = "c54aa92e2f6cc813444dd6f96cb66a3a70dd4ece";
      hash = "sha256-ltZ+uz/J3GFOznOm7gs8M02hB9oYTHb8uBABDmcjoZI=";
    };
    cargoHash = "sha256-22wGFLkuY8C91cuPg66BGDboy+HOFhIYMN/aqLsxtc4=";
    doCheck = false;
    meta = {
      description = "A nushell plugin to parse JSON files using JSONPath";
      homepage = "https://github.com/fdncred/nu_plugin_json_path";
      license = with pkgs.lib.licenses; [ mit ];
      mainProgram = "nu_plugin_json_path";
    };
  };

  nu_plugin_strutils = pkgs.rustPlatform.buildRustPackage {
    pname = "nu_plugin_strutils";
    version = "0.19.0";

    src = pkgs.fetchFromGitHub {
      owner = "fdncred";
      repo = "nu_plugin_strutils";
      rev = "5e7463ffa80fdb94e94bcbd9228c59b61e416422";
      hash = "sha256-AiUD3xeoiSSl6uA+miN3sgya43eJ5ac3Aji0w6tnn4I=";
    };
    cargoHash = "sha256-TrA5KyATQ5VaS+0sTly4bDc79IuXAyERfbf7aw36BMc=";
    doCheck = false;
    meta = {
      description = "A collection of string utilities for Nushell";
      homepage = "https://github.com/fdncred/nu_plugin_strutils";
      license = with pkgs.lib.licenses; [ mit ];
      mainProgram = "nu_plugin_strutils";
    };
  };

  nu_plugin_regex = pkgs.rustPlatform.buildRustPackage {
    pname = "nu_plugin_regex";
    version = "0.20.0";

    src = pkgs.fetchFromGitHub {
      owner = "fdncred";
      repo = "nu_plugin_regex";
      rev = "a9501ca410cdc7dfdf85f17ce4e5ffee7fd19576";
      hash = "sha256-E0CnjckAY176cdn8ZwlzM/opGieGqr7iA5NhEJnlOWc=";
    };
    cargoHash = "sha256-u5bdrITNJanj+5DG+FmnKClivQ2qrZ2JtdHlw70UmXY=";
    doCheck = false;
    meta = {
      description = "A Nushell plugin to search text with regex";
      homepage = "https://github.com/fdncred/nu_plugin_regex";
      license = with pkgs.lib.licenses; [ mit ];
      mainProgram = "nu_plugin_regex";
    };
  };

  nu_plugin_to_gui = pkgs.rustPlatform.buildRustPackage {
    pname = "nu_plugin_to_gui";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "fdncred";
      repo = "nu_plugin_to_gui";
      rev = "d6400589c973fe12fe916958043f9957fdce8203";
      hash = "sha256-C5OvSImyK8mgAIMrGZlkDEGHNk4lRx9KS/mPRQ2zaog=";
    };
    cargoHash = "sha256-QPlJffqMV/IdbUlXG5oEKdKJPdpcT2/hUH+uFkdzLVA=";
    doCheck = false;
    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [ libxcb libxkbcommon ];
    meta = {
      description = "A Nushell plugin to display data in a GUI";
      homepage = "https://github.com/fdncred/nu_plugin_to_gui";
      license = with pkgs.lib.licenses; [ mit ];
      mainProgram = "nu_plugin_to_gui";
    };
  };
in
{
  home.packages = with pkgs; [
    nushell
    nufmt
  ];

  programs.nushell = {
    enable = true;

    plugins = with pkgs; [
      nushellPlugins.polars
      nushellPlugins.query
      # nushellPlugins.skim
      # nushellPlugins.desktop_notifications
      # nushellPlugins.highlight
      # nu_plugin_file
      # nu_plugin_toon
      # nu_plugin_json_path
      # nu_plugin_strutils
      # nu_plugin_regex
      # nu_plugin_to_gui
    ];
    configFile = {
      text = ''
        let fish_completer = {|spans|
            fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
            | from tsv --flexible --noheaders --no-infer
            | rename value description
            | update value {|row|
              let value = $row.value
              let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
              if ($need_quote and ($value | path exists)) {
                let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
                $'"($expanded_path | str replace --all "\"" "\\\"")"'
              } else {$value}
            }
        }

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
          completions: {
            external: {
              enable: true
              completer: $fish_completer
            }
          }
        }
      '';
    };
  };
}
