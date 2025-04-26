{
  defaults,
  pkgs,
  ...
} @ args: let
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    policies = import ./_policies.nix args;
    profiles."${defaults.username}" = import ./_profile.nix args;
    # nativeMessagingHosts = [pkgs.firefoxpwa];
  };

  stylix.targets.firefox.profileNames = ["${defaults.username}"];
}
