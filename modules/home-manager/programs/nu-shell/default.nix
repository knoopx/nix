{ nixosConfig
, config
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
    nushell # Modern shell written in Rust
    nufmt # Nushell formatter
  ];

  home.file."${config.xdg.dataHome}/nushell/vendor/autoload/git.nu" = {
    source = ./completions/git.nu;
  };

  programs.nushell = {
    enable = true;

    plugins = with pkgs; [
      # nushellPlugins.polars
      # nushellPlugins.query
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

    settings = {
      show_banner = false;
    };

    configFile.text = ''
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

      def cd_projects [] {
          ^find ~/Projects -maxdepth 2 -type d
          | ^sk --select-1 --layout reverse --border
          | str trim
      }

      def pick_frequent_command [] {
          let frequent = ($env.HOME + "/.frequent-commands")
          if ($frequent | path exists) {
              let query = (commandline)
              let result = (^cat $frequent | ^sort -r | ^sk --no-sort --no-multi -q $query | str trim)
              if ($result != "") {
                  commandline edit $result
              }
          }
      }

      def skim-history-widget [] {
          let query = (commandline)
          let result = (history | get command | ^sk --no-sort --no-multi -q $query | str trim)
          if ($result != "") {
              commandline edit $result
          }
      }

      $env.config.keybindings ++= [
        {
          name: clear_screen
          modifier: control
          keycode: char_l
          mode: emacs
          event: { send: ClearScrollback }
        }
        
        {
          name: quit_shell
          modifier: control
          keycode: char_q
          mode: emacs
          event: {
            send: ExecuteHostCommand
            cmd: "exit"
          }
        }

        {
          name: undo
          modifier: control
          keycode: char_z
          mode: emacs
          event: { edit: Undo }
        }
        {
          name: redo
          modifier: shift_control
          keycode: char_z
          mode: emacs
          event: { edit: Redo }
        }

        {
          name: history
          modifier: control
          keycode: char_r
          mode: emacs
          event: {
            send: ExecuteHostCommand
            cmd: "skim-history-widget"
          }
        }

        {
          name: copy_selection
          modifier: control
          keycode: char_c
          mode: emacs
          event: { edit: CopySelection }
        }
        {
          name: paste_clipboard
          modifier: control
          keycode: char_v
          mode: emacs
          event: { edit: Paste }
        }

        {
          name: select_all
          modifier: control
          keycode: char_a
          mode: emacs
          event: { edit: SelectAll }
        }

        {
          name: move_word_left
          modifier: control
          keycode: left
          mode: emacs
          event: { edit: MoveWordLeft }
        }
        
        {
          name: move_word_right
          modifier: control
          keycode: right
          mode: emacs
          event: { edit: MoveWordRight }
        }

        {
          name: goto_line_start
          modifier: none
          keycode: home
          mode: emacs
          event: { edit: MoveToLineStart }
        }
        
        {
          name: goto_line_end
          modifier: none
          keycode: end
          mode: emacs
          event: { edit: MoveToLineEnd }
        }

        {
          name: goto_file_start
          modifier: control
          keycode: home
          mode: emacs
          event: { edit: MoveToStart }
        }
        
        {
          name: goto_last_line
          modifier: control
          keycode: end
          mode: emacs
          event: { edit: MoveToEnd }
        }

        {
          name: page_up
          modifier: none
          keycode: pageup
          mode: emacs
          event: { send: MenuPrevious }
        }
        
        {
          name: page_down
          modifier: none
          keycode: pagedown
          mode: emacs
          event: { send: MenuNext }
        }

        {
          name: delete_word_backward
          modifier: control
          keycode: char_h
          mode: emacs
          event: { edit: BackspaceWord }
        }
        
        {
          name: delete_word_forward
          modifier: control
          keycode: delete
          mode: emacs
          event: { edit: DeleteWord }
        }

        {
          name: launch_cd_projects
          modifier: control
          keycode: char_e
          mode: emacs
          event: {
            send: ExecuteHostCommand
            cmd: "cd (cd_projects)"
          }
        }
        
        {
          name: launch_pick_frequent_command
          modifier: shift_control
          keycode: char_r
          mode: emacs
          event: {
            send: ExecuteHostCommand
            cmd: "pick_frequent_command"
          }
        }
        
        {
          name: launch_hx
          modifier: control
          keycode: char_j
          mode: emacs
          event: {
            send: ExecuteHostCommand
            cmd: "hx"
          }
        }
        
        {
          name: launch_jjui
          modifier: control
          keycode: char_k
          mode: emacs
          event: {
            send: ExecuteHostCommand
            cmd: "jjui"
          }
        }
        
        {
          name: launch_pi
          modifier: control
          keycode: char_p
          mode: emacs
          event: {
            send: ExecuteHostCommand
            cmd: "pi"
          }
        }
      ]

      $env.config.color_config = {
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

      $env.config.completions = {
        external: {
          enable: true
          completer: $fish_completer
        }
      }
    '';
  };
}
