{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libnotify
    gnome-monitor-config
  ];
}
