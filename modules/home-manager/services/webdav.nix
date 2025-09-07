{
  pkgs,
  lib,
  config,
  ...
}: {
  systemd.user.services.webdav-documents = {
    Install.WantedBy = ["default.target"];

    Unit = {
      After = ["network.target"];
      Description = "rclone webdav server";
    };

    Service = {
      ExecStart = builtins.toString (pkgs.writeShellScript "webdav-documents" ''
        ${lib.getExe pkgs.rclone} serve webdav ${config.home.homeDirectory}/Documents --addr :5006 --user knoopx --pass $(secret-tool lookup webdav password | head | tr -d "\n")
      '');
      Restart = "always";
    };
  };
}