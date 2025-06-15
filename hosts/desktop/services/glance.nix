{...}: {
  services.traefik-proxy = {
    hostServices = {
      glance = 9000;
    };
  };
}
