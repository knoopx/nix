{ pkgs, ... }: {
  # Dashboard welcome screen: desktop installs gogcli, so its
  # events/inbox data sources work.
  programs.fish.interactiveShellInit = ''
    ${pkgs.dashboard}/bin/dashboard
  '';
}
