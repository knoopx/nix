{
  lib,
  pkgs,
  ...
}: {
  security.pam.services.greetd = {
    enableGnomeKeyring = true;
  };

  services.greetd = {
    enable = true;
    vt = 1;
    settings = {
      default_session = {
        # command = "${pkgs.cage}/bin/cage -s -- ${lib.getExe pkgs.greetd.regreet}";
        # command = "${pkgs.greetd.greetd}/bin/agreety --cmd niri-session";
        command = "${lib.getExe pkgs.greetd.tuigreet} --time";
        user = "greeter";
      };
    };
  };
}
