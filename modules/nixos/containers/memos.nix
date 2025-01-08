{
  pkgs,
  lib,
  defaults,
  ...
}: let
  name = "memos";
  root = "/mnt/storage/memos";
  pkg = pkgs.mkStylixMemosPkg defaults.colorScheme.palette;
in {
  # TODO: https://github.com/usememos/telegram-integration

  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;
      image = "${name}:${pkg.version}";
      imageFile =
        pkgs.dockerTools.buildImage
        {
          inherit name;
          tag = pkg.version;
          copyToRoot = pkgs.buildEnv {
            name = "${pkg.name}-env";
            paths = [pkgs.bash pkgs.coreutils pkg];
            pathsToLink = ["/bin"];
          };
          runAsRoot = ''
            mkdir -p /var/opt/memos
          '';
          config = {
            Cmd = [(lib.getExe pkg)];
            ExposedPorts = {
              "8081/tcp" = {};
            };
          };
        };
      volumes = [
        "${root}:/var/opt/memos"
      ];
      environment = {
        MEMOS_MODE = "prod";
      };
    };
  };
}
