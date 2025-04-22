{config, ...}: {
  home.file."${config.xdg.configHome}/television/config.toml".text = ''
    [ui]
    use_nerd_font_icons = true
    input_bar_position = "top"
    theme = "catppuccin"

    [previewers.file]
    theme = "${config.programs.bat.config.theme}"
  '';

  home.file."${config.xdg.configHome}/television/channels.toml".text = ''
    [[cable_channel]]
    name = "git-diff"
    source_command = "git diff --name-only"
    preview_command = "git diff --color=always {0}"

    [[cable_channel]]
    name = "git-reflog"
    source_command = 'git reflog'
    preview_command = 'git show -p --stat --pretty=fuller --color=always {0}'

    [[cable_channel]]
    name = "git-log"
    source_command = "git log --oneline --date=short --pretty=\"format:%h %s %an %cd\" \"$@\""
    preview_command = "git show -p --stat --pretty=fuller --color=always {0}"

    [[cable_channel]]
    name = "git-branch"
    source_command = "git --no-pager branch --all --format=\"%(refname:short)\""
    preview_command = "git show -p --stat --pretty=fuller --color=always {0}"

    [[cable_channel]]
    name = "history"
    source_command = "fish -c 'history'"

    [[cable_channel]]
    name = "nixpkgs"
    source_command = "nix-search-tv print"
    preview_command = "nix-search-tv preview {}"
  '';
}
