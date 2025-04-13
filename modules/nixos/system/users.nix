{
  pkgs,
  defaults,
  ...
}: {
  # users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  users.users.root.initialPassword = defaults.password;

  users.users.${defaults.username} = {
    isNormalUser = true;

    description = defaults.full-name;
    initialPassword = defaults.password;

    shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager" "audio" "video" "docker" "lxd" "kvm" "libvirtd" "qemu-libvirtd" "adbusers"];

    openssh.authorizedKeys.keys = let
      authorizedKeys = pkgs.fetchurl defaults.pubKeys;
    in
      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };
}
