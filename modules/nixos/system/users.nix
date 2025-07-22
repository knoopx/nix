{
  pkgs,
  config,
  ...
}: {
  # users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  users.users.root.initialPassword = config.defaults.password;

  users.users.${config.defaults.username} = {
    isNormalUser = true;

    description = config.defaults.fullName;
    initialPassword = config.defaults.password;

    shell = pkgs.fish;
    extraGroups = [
      "adbusers"
      "audio"
      "docker"
      "input"
      "iio"
      "sensor"
      "kvm"
      "libvirtd"
      "lxd"
      "networkmanager"
      "qemu-libvirtd"
      "users"
      "video"
      "wheel"
      "ydotool"
    ];

    openssh.authorizedKeys.keys = let
      authorizedKeys = config.defaults.pubKeys;
    in
      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };
}
