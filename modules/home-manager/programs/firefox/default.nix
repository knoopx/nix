{
  nixosConfig,
  pkgs,
  ...
} @ args: let
  brotabMediatorJson = pkgs.writeTextFile {
    name = "brotab_mediator.json";
    text = builtins.toJSON {
      name = "brotab_mediator";
      description = "This mediator exposes interface over TCP to control browser's tabs";
      path = "${pkgs.brotab}/bin/bt_mediator";
      type = "stdio";
      allowed_extensions = ["brotab_mediator@example.org"];
    };
  };
in {
  home.file.".mozilla/native-messaging-hosts/brotab_mediator.json".source = brotabMediatorJson;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
    policies = import ./_policies.nix args;
    profiles."${nixosConfig.defaults.username}" = import ./_profile.nix args;
  };

  stylix.targets.firefox.profileNames = ["${nixosConfig.defaults.username}"];
}
