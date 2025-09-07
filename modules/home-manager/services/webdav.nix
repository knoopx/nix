{
  pkgs,
  lib,
  config,
  ...
}: let
  port = 5006;
  user = config.home.username;
in {
  systemd.user.services.webdav-documents = {
    Install.WantedBy = ["default.target"];

    Unit = {
      After = ["network.target"];
      Description = "rclone webdav server";
    };

    Service = {
      ExecStart = builtins.toString (pkgs.writeShellScript "webdav-documents" ''
        ${lib.getExe pkgs.rclone} serve webdav ${config.home.homeDirectory}/Documents --allow-origin "knoopx.github.io" --addr :${toString port} --user ${user} --pass $(secret-tool lookup webdav password | head | tr -d "\n")
      '');
      Restart = "always";
    };
  };
}
