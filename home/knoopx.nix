{...} @ inputs: let
  recusiveFilterNixModules = import ../lib/recusiveFilterNixModules.nix inputs;
in {
  imports = recusiveFilterNixModules ../modules/home-manager;

  home = {
    stateVersion = "24.05";
    username = "knoopx";
  };
}
