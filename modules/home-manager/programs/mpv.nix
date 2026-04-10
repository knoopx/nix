{ pkgs, ... }: {
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.sponsorblock-minimal ];
  };
}
