{pkgs, ...}: {
  home.shell.enableFishIntegration = true;

  programs = {
    fish = {
      enable = true;
      generateCompletions = false;

      plugins = [
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
        {
          name = "fzf.fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
      ];

      shellAbbrs = {
        ls = "eza --icons -lah";
        pbpaste = "fish_clipboard_paste";
        pbcopy = "fish_clipboard_copy";
      };

      interactiveShellInit = ''
        set fish_greeting

        for line in (skate list @env-keys | cut -f1)
            set -gx (echo $line | tr '[:lower:]' '[:upper:]') (skate get $line@env-keys)
        end

        fish_add_path -g "$HOME/.cache/.bun/bin"
        fish_add_path -g "$HOME/.cargo/bin"
        fish_add_path -g "$HOME/.local/bin/"
        fish_add_path -g "$HOME/bin/"
        fish_add_path -g "$HOME/go/bin"

        set -x LD_LIBRARY_PATH "/run/opengl-driver/lib/:$NIX_LD_LIBRARY_PATH"
        set -x LIBRARY_PATH "$LD_LIBRARY_PATH"
        set -gx TRITON_LIBCUDA_PATH /run/opengl-driver/lib/

        set -x INTELLI_VARIABLE_HOTKEY "ctrl-k"
      '';
    };
  };
}
