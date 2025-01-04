{pkgs, ...}: {
  environment.defaultPackages = [];
  environment.systemPackages = with pkgs; [
  ];
}
