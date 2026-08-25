{
  nixosConfig,
  lib,
  pkgs,
  ...
} @ args: let
  cfg = nixosConfig.defaults.firefox;

  # Maintainer-patched manifest shipped by the bruvtab flake package
  # (its postInstall rewrites .path to <out>/bin/bruvtab_mediator).
  bruvtabMediatorJson = "${pkgs.bruvtab}/lib/mozilla/native-messaging-hosts/bruvtab_mediator.json";
in {
  home.file.".mozilla/native-messaging-hosts/bruvtab_mediator.json" =
    lib.mkIf cfg.nativeMessaging {
      source = bruvtabMediatorJson;
    };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
    policies = lib.mkIf cfg.policies (import ./_policies.nix args);
    profiles."${nixosConfig.defaults.username}" = import ./_profile.nix args;
  };

  stylix.targets.firefox.profileNames = ["${nixosConfig.defaults.username}"];
}
