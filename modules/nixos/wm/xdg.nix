{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libsecret # Password and secrets storage library
  ];

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "*";
    };
  };
}
