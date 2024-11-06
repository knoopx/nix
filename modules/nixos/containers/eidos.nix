_: let
  name = "eidos";
in {
  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;
      image = "ghcr.io/mayneyao/eidos";
    };
  };
}
