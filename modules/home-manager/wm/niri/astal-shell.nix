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
}
