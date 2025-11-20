{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libsecret
  ];

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "*";
    };
  };
}
