{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    scripts = [
      pkgs.mpvScripts.mpris
      pkgs.mpvScripts.sponsorblock-minimal
    ];
  };
}
