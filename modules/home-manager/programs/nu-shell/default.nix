{
  nixosConfig,
  config,
  ...
}: let
  colors = nixosConfig.defaults.colorScheme.palette;
in {
  home.file."${config.xdg.dataHome}/nushell/vendor/autoload/git.nu" = {
    source = ./completions/git.nu;
  };

  programs.nushell = {
    enable = true;
    configFile = {
      text = ''
        # Keybindings (aligned with helix/kitty conventions)
        $env.config.keybindings --+= [
          # Clear screen / Quit
          {
            name: "clear_screen"
            modifier: control
            keycode: char_l
            mode: emacs
            event: { send: clearscreen }
          }
          {
            name: "quit_shell"
            modifier: control
            keycode: char_q
            mode: emacs
            event:
              { send: executehostcommand
                cmd: "exit"
              }
          }

          # Undo/Redo
          {
            name: "undo"
            modifier: control
            keycode: char_z
            mode: emacs
            event: { edit: undo }
          }
          {
            name: "redo"
            modifier: shift_control
            keycode: char_z
            mode: emacs
            event: { edit: redo }
          }

          # Search (like helix Ctrl-f)
          {
            name: "search_history"
            modifier: control
            keycode: char_f
            mode: emacs
            event: { send: searchhistory }
          }

          # Clipboard (system clipboard)
          {
            name: "copy_to_clipboard"
            modifier: control
            keycode: char_c
            mode: emacs
            event: { edit: copselectionsystem }
          }
          {
            name: "paste_from_clipboard"
            modifier: control
            keycode: char_v
            mode: emacs
            event: { edit: pastesystem }
          }

          # Text selection
          {
            name: "select_all"
            modifier: control
            keycode: char_a
            mode: emacs
            event: { edit: selectall }
          }

          # Word navigation (like helix)
          {
            name: "move_word_left"
            modifier: control
            keycode: left
            mode: emacs
            event: { edit: movewordleft }
          }
          {
            name: "move_word_right"
            modifier: control
            keycode: right
            mode: emacs
            event: { edit: movewordright }
          }

          # Line navigation (like helix)
          {
            name: "goto_line_start"
            modifier: none
            keycode: home
            mode: emacs
            event: { edit: movetolinestart }
          }
          {
            name: "goto_line_end"
            modifier: none
            keycode: end
            mode: emacs
            event: { edit: movetolineend }
          }

          # File start/end (like helix)
          {
            name: "goto_file_start"
            modifier: control
            keycode: home
            mode: emacs
            event: { edit: movetostart }
          }
          {
            name: "goto_last_line"
            modifier: control
            keycode: end
            mode: emacs
            event: { edit: movetoend }
          }

          # Page navigation (like helix)
          # Note: reedline has no page-up/page-down events; these scroll menu items only
          {
            name: "page_up"
            modifier: none
            keycode: pageup
            mode: emacs
            event: { send: menuprevious }
          }
          {
            name: "page_down"
            modifier: none
            keycode: pagedown
            mode: emacs
            event: { send: menunext }
          }

          # Delete (like helix)
          {
            name: "delete_word_backward"
            modifier: control
            keycode: backspace
            mode: emacs
            event: { edit: backspaceword }
          }
          {
            name: "delete_word_forward"
            modifier: control
            keycode: delete
            mode: emacs
            event: { edit: deleteword }
          }

          # Indent/Outdent (like helix)
          {
            name: "indent"
            modifier: none
            keycode: tab
            mode: emacs
            event: { edit: indent }
          }
          {
            name: "outdent"
            modifier: shift
            keycode: tab
            mode: emacs
            event: { edit: outdent }
          }
        ]

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
