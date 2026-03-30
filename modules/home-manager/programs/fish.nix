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
      ];

      shellAbbrs = {
        ls = "eza --icons -lah";
        pbpaste = "wl-copy";
        pbcopy = "wl-paste";
      };

      interactiveShellInit = ''
        set fish_greeting

        fish_add_path -g "$HOME/.cache/.bun/bin"
        fish_add_path -g "$HOME/.cargo/bin"
        fish_add_path -g "$HOME/.local/bin/"
        fish_add_path -g "$HOME/bin/"
        fish_add_path -g "$HOME/go/bin"

        set -x LD_LIBRARY_PATH "/run/opengl-driver/lib/:$NIX_LD_LIBRARY_PATH"
        set -x LIBRARY_PATH "$LD_LIBRARY_PATH"
        set -gx TRITON_LIBCUDA_PATH /run/opengl-driver/lib/

        bind \cp "sk --layout reverse --border --preview 'bat --color=always {}' | xargs -r micro"
        function cd_projects
          set -l selected (find ~/Projects -maxdepth 2 -type d | sk --select-1 --layout reverse --border)
          cd "$selected"
        end
        bind \ce "cd_projects"
      '';
    };
  };
}
