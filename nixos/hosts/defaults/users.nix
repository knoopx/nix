{
  pkgs,
  defaults,
  ...
}: {
  # users.mutableUsers = false;

  users.defaultUserShell = pkgs.fish;
  users.users.root.initialPassword = defaults.password;

  boot.initrd.preLVMCommands = ''
    echo
    echo '################################### NOTICE ###################################'
    echo
    echo 'This device is property of ${defaults.full-name}'
    echo 'If found please contact ${defaults.personal-email}'
    echo
    echo '################################### NOTICE ###################################'
    echo
  '';

  # TODO: avatars
  # system.activationScripts.script.text = ''
  #   cp /home/knoopx/.dotfiles/profile-pic.png /var/lib/AccountsService/icons/knoopx
  # '';

  users.users.${defaults.username} = {
    isNormalUser = true;

    description = defaults.full-name;
    initialPassword = defaults.password;

    shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager" "video" "docker" "lxd" "libvirtd"];

    openssh.authorizedKeys.keys = let
      authorizedKeys = pkgs.fetchurl defaults.pubKeys;
    in
      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };
}
