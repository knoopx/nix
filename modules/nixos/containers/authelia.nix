_: let
  name = "auth";
in {
  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;
      image = "authelia/authelia";
      labels = {
        "traefik.http.middlewares.${name}.forwardAuth.address" = "http://${name}:9091/api/authz/forward-auth";
        # 'traefik.http.middlewares.authelia.forwardAuth.address=http://authelia:9091/api/authz/forward-auth?authelia_url=https%3A%2F%2Fauth.example.com%2F'
        "traefik.http.middlewares.${name}.forwardAuth.trustForwardHeader" = "true";
        "traefik.http.middlewares.${name}.forwardAuth.authResponseHeaders" = "Remote-User,Remote-Groups,Remote-Email,Remote-Name";
      };
    };
  };
}
