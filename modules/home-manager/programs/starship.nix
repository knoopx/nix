{...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;

    settings = {
      add_newline = true;
      format = "$all";

      git_branch.disabled = true;
      git_commit.disabled = true;
      git_metrics.disabled = true;
      git_state.disabled = true;
      git_status.disabled = true;

      custom.jj = {
        format = "on [$symbol $output]($style) ";
        command = ''
          jj log -r'ancestors(@) & bookmarks()' --no-graph -n1 -T 'bookmarks.join(", ")'
        '';
        when = "jj --ignore-working-copy root";
        symbol = "󰃀";
      };
    };
  };
}
