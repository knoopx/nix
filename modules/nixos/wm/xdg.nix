{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libsecret
  ];

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
    
    # Enable XDG Sound Theme specification support
    sounds.enable = true;
  };
}
