{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    openra
  ];
}

