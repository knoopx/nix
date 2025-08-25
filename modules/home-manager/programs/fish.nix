{
  pkgs,
  nixosConfig,
  ...
}: {
  home.shell.enableFishIntegration = true;

  programs = {
    fish = {
      enable = true;

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
        nix-shell = "nix-shell --command fish";
        nixos-upgrade = "nh os switch path:~/.dotfiles";
        ls = "eza -lah";
        pbpaste = "fish_clipboard_paste";
        pbcopy = "fish_clipboard_copy";
      };

      interactiveShellInit = ''
        set fish_greeting

        set -gx DEEPSEEK_API_KEY (secret-tool lookup deepseek-api key | head | tr -d "\n")
        set -gx GITHUB_PERSONAL_ACCESS_TOKEN (secret-tool lookup github token | head | tr -d "\n")
        set -gx OPENAI_API_BASE "${nixosConfig.ai.baseURL}/v1"

        fish_add_path -g "$HOME/.bun/bin"
        fish_add_path -g "$HOME/.cargo/bin:"
        fish_add_path -g "$HOME/.local/bin/"
        fish_add_path -g "$HOME/.local/share/gem/ruby/3.1.0/bin/"
        fish_add_path -g "$HOME/bin/"
        fish_add_path -g "$HOME/go/bin"
        fish_add_path -g "$HOME/.opencode/bin"

        set -x LD_LIBRARY_PATH "/run/opengl-driver/lib/:$NIX_LD_LIBRARY_PATH"
        set -x LIBRARY_PATH "$LD_LIBRARY_PATH"
        set -gx TRITON_LIBCUDA_PATH /run/opengl-driver/lib/
      '';
    };
  };
}
