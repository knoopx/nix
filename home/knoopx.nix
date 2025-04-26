{niri, ...} @ inputs: let
  listNixModulesRecusive = import ../lib/listNixModulesRecusive.nix inputs;
in {
  imports = [niri.homeModules.niri] ++ (listNixModulesRecusive ../modules/home-manager);

  home = {
    stateVersion = "24.05";
    username = "knoopx";
  };
}
