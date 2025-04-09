{
  pkgs,
  defaults,
  lib,
  ...
}: let
  msg = pkgs.stdenvNoCC.mkDerivation {
    name = "message.txt";
    phases = ["buildPhase"];
    buildPhase = with defaults; ''
      ${lib.getExe pkgs.gum} style \
        --border-foreground '#${colorScheme.palette.base08}' --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        'This device is property of ${full-name}' \
        'If found please contact ${primary-email}' > $out
    '';
  };
in {
  # users.mutableUsers = false;

  users.defaultUserShell = pkgs.fish;
  users.users.root.initialPassword = defaults.password;

  boot.initrd.preLVMCommands = ''
    cat "${msg}"
  '';

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
