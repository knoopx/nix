{...} @ inputs: let
  listNixModulesRecusive = import ../lib/listNixModulesRecusive.nix inputs;
in {
  imports = listNixModulesRecusive ../modules/home-manager;

  home = {
    stateVersion = "24.05";
    username = "knoopx";
  };

  gtk.gtk4.theme = null;
  programs.git.signing.format = null;

  programs.man.enable = false;
  fonts.fontconfig.enable = false;
}
