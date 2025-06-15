{config, ...}: {
  environment.etc."paperless-admin-pass".text = "admin";

  services.traefik-proxy = {
    hostServices = {
      paperless = 28981;
    };
  };

  services.paperless = {
    enable = true;
    passwordFile = "/etc/paperless-admin-pass";
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "spa+cat+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
      PAPERLESS_URL = "https://paperless.${config.services.traefik-proxy.domain}";
    };
  };
}
