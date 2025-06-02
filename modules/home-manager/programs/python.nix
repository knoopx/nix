{pkgs, ...}: let
  python = pkgs.python312.withPackages (ps:
    with ps; [
      matplotlib
      pillow
      pygobject-stubs
      pygobject3
      requests
    ]);
in {
  home.packages = [python];
  # home.sessionVariables = {
  #   PYTHONPATH = "${python}/${pkgs.python312.sitePackages}";
  # };
  # systemd.user.sessionVariables = {
  #   PYTHONPATH = "${python}/${pkgs.python312.sitePackages}";
  # };
  programs = {
    vscode = {
      profiles.default = {
        userSettings = {
          "python.analysis.languageServerMode" = "full";
          "python.analysis.extraPaths" = [
            "${python}/${pkgs.python312.sitePackages}"
          ];
          "python.analysis.include" = [
            "${python}/${pkgs.python312.sitePackages}"
          ];
        };
      };
    };
  };

  # programs.fish.interactiveShellInit = ''
  #   set -gx PYTHONPATH "${python}/${pkgs.python312.sitePackages}"
  # '';
}
