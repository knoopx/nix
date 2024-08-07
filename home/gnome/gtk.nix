{pkgs, ...}: {
  gtk = {
    iconTheme = {
      # package = pkgs.dracula-icon-theme;
      # name = "Dracula";
      package = pkgs.morewaita-icon-theme;
      name = "MoreWaita";
    };
  };
}
