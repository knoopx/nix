{
  ags,
  astal-shell,
  pkgs,
  ...
}: {
  imports = [ags.homeManagerModules.default];

  programs.ags = {
    enable = true;
    configDir = null; # Don't symlink since we're using the bundled version
    extraPackages = [
      astal-shell.packages.${pkgs.system}.default
    ];
  };

  systemd.user.services.astal-shell = {
    Unit = {
      Description = "Astal Shell";
      After = ["graphical-session.target"];
      Wants = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${astal-shell.packages.${pkgs.system}.default}/bin/astal-shell";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
