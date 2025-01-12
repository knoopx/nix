{
  defaults,
  pkgs,
  ...
} @ args: let
in {
  imports = [
    ../glance
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    policies = import ./policies.nix args;
    profiles."${defaults.username}" = import ./profile.nix args;
  };
}
