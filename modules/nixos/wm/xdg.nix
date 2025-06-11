{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libsecret
  ];

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
