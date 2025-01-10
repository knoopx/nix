_: let
  name = "sheets";
  root = "/mnt/storage/baserow";
  public-url = "https://${name}.knoopx.net";
in {
  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;
      image = "baserow/baserow:latest";
      volumes = [
        "${root}:/baserow/data"
      ];
      environment = {
        BASEROW_PUBLIC_URL = public-url;
      };
    };
  };
}
