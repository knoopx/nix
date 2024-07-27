{
  defaults,
  stylix,
  ...
}: {
  # stylix.targets.kitty.enable = false;

  home.file = {
    ".local/bin" = {
      source = ../assets/scripts;
      recursive = true;
      executable = true;
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };

    fish = {
      enable = true;

      shellAliases = {
        nix-shell = "nix-shell --command fish";
      };

      shellAbbrs = {
        dc = "docker-compose";
        ls = "eza -lah";
        pbpaste = "fish_clipboard_paste";
        pbcopy = "fish_clipboard_copy";
      };

      functions = {
        # TODO: find/develop some kind of history manager and automatic switcher

        fzf-silverbullet = ''
          set -l docs_dir "$HOME/Knowledge Base"

          pushd "$docs_dir"

          fd --type f -e md . | grep -v Library/Core | grep -v Templates | awk '{print substr($0, 1, length($0)-3) "\t" $0}' | sort --ignore-case | fzf --reverse --with-nth=1 --preview-window=right:70% \
              --delimiter='\t' \
              --preview 'glow --style=dark {2}' \
              --bind="enter:execute(fzf-silverbullet-open {2})"
              # --bind="enter:execute-silent(fzf-silverbullet-open {2})"

          popd
        '';
      };
    };

    yazi = {
      enable = true;

      # TODO

      settings = {
        manager = {
          # ratio = [1 2 4];
          # sort_dir_first = true;
          # linemode = "mtime";
        };

        preview = {
          # tab_size = 4;
          # image_filter = "lanczos3";
          # max_width = 1920;
          # max_height = 1080;
          # image_quality = 90;
        };
      };

      keymap = {
        manager.prepend_keymap = [
          # {
          #   run = "remove --force";
          #   on = ["d"];
          # }
        ];
      };
    };

    kitty = {
      enable = true;

      # TODO: stylix overrides colors
      settings = {
        active_tab_font_style = "bold";
        active_tab_foreground = "#1E1E3F";
        confirm_os_window_close = 0;
        cursor_shape = "block";
        font_size = 10;
        hide_window_decorations = "yes";
        inactive_tab_background = "#FAD000";
        tab_bar_background = "#FAD000";
        tab_bar_edge = "top";
        tab_bar_margin_width = 5;
        tab_bar_style = "separator";
        tab_separator = " ";
        tab_title_template = " {fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title} ";
        window_padding_width = 5;
      };

      #   extraConfig = with stylix.base16Scheme; ''
      #     foreground #${base05}
      #     background #${base00}
      #     color0  #${base03}
      #     color1  #${base08}
      #     color2  #${base0B}
      #     color3  #${base09}
      #     color4  #${base0D}
      #     color5  #${base0E}
      #     color6  #${base0C}
      #     color7  #${base06}
      #     color8  #${base04}
      #     color9  #${base08}
      #     color10 #${base0B}
      #     color11 #${base0A}
      #     color12 #${base0C}
      #     color13 #${base0E}
      #     color14 #${base0C}
      #     color15 #${base07}
      #     color16 #${base00}
      #     color17 #${base0F}
      #     color18 #${base0B}
      #     color19 #${base09}
      #     color20 #${base0D}
      #     color21 #${base0E}
      #     color22 #${base0C}
      #     color23 #${base06}
      #     cursor  #${base07}
      #     cursor_text_color #${base00}
      #     selection_foreground #${base01}
      #     selection_background #${base0D}
      #     url_color #${base0C}
      #     active_border_color #${base04}
      #     inactive_border_color #${base00}
      #     bell_border_color #${base03}
      #     tab_bar_style fade
      #     tab_fade 1
      #     active_tab_foreground   #${base04}
      #     active_tab_background   #${base00}
      #     active_tab_font_style   bold
      #     inactive_tab_foreground #${base07}
      #     inactive_tab_background #${base08}
      #     inactive_tab_font_style bold
      #     tab_bar_background #${base00}
      #   '';
    };

    git = {
      enable = true;
      userName = defaults.full-name;
      userEmail = defaults.personal-email;

      aliases = {
        d = "diff";
        co = "checkout";
        cp = "cherry-pick";
        l = "log --pretty=format:'%C(black)%h%Creset%C(red)%d%Creset %s %Cgreen(%cr) %C(black)%an%Creset' --abbrev-commit";
        b = "branch";
        bb = "branch -v";
        s = "status";
        g = "log --graph --pretty=format:'%Cgreen%h%Creset -%C(yellow)%d%Creset %s %C(black)(%cr)%Creset' --abbrev-commit --date=relative";
        unstage = "reset HEAD";
        reset-permissions = "git push origin devel help config  diff -p | grep -E '^(diff|old mode|new mode)' | sed -e 's/^old/NEW/;s/^new/old/;s/^NEW/new/' | git apply";
      };

      attributes = [
        "*.lockb binary diff=lockb"
      ];

      extraConfig = {
        color = {
          diff = "auto";
          status = "auto";
          branch = "auto";
        };

        diff.lockb = {
          textconv = "bun";
          binary = true;
        };

        core = {
          editor = defaults.editor;
          autocrlf = false;
          quotePath = false;
        };

        push = {
          default = "simple";
          autoSetupRemote = true;
        };
        pull.rebase = true;
        branch.autosetuprebase = "always";
        init.defaultBranch = "master";
        rerere.enabled = true;
        color.ui = true;

        apply = {
          whitespace = "fix";
        };

        blame = {
          date = "relative";
        };
      };

      diff-so-fancy.enable = true;
    };
  };
}
