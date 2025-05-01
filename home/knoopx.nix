{yay-nix, ...} @ inputs: let
  listNixModulesRecusive = import ../lib/listNixModulesRecusive.nix inputs;
in {
  imports = [yay-nix.homeManagerModules.default] ++ (listNixModulesRecusive ../modules/home-manager);

  home = {
    stateVersion = "24.05";
    username = "knoopx";
  };
}
