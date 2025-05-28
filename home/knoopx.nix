{...} @ inputs: let
  listNixModulesRecusive = import ../lib/listNixModulesRecusive.nix inputs;
in {
  imports = listNixModulesRecusive ../modules/home-manager;

  home = {
    stateVersion = "24.05";
    username = "knoopx";
  };
}
