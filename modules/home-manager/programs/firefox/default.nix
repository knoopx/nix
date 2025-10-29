{
  nixosConfig,
  pkgs,
  ...
} @ args: let
in {
  programs.firefox = {
    enable = true;
    policies = import ./_policies.nix args;
    profiles."${nixosConfig.defaults.username}" = import ./_profile.nix args;
  };

  stylix.targets.firefox.profileNames = ["${nixosConfig.defaults.username}"];
}
