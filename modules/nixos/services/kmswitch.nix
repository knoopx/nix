{ config, lib, pkgs, ... }:

# KMSwitch input-sharing prerequisites, fully via Nix (no manual sudo):
#   - load the uinput kernel module (client injects input via /dev/uinput)
#   - put the user in the `input` + `uinput` groups (read /dev/input, write /dev/uinput)
#   - udev rules granting those devices to the `input` group
#
# Picked up by every host that imports modules/nixos (desktop + hi10max).
{
  boot.kernelModules = [ "uinput" ];

  users.users.${config.defaults.username}.extraGroups = [ "input" "uinput" ];

  # Open the KMSwitch server port (TCP) and discovery port (UDP) so the
  # hi10max client can reach the desktop server across the firewall.
  networking.firewall = {
    allowedTCPPorts = [ 47801 ];
    allowedUDPPorts = [ 47802 ];
  };

  services.udev.extraRules = ''
    KERNEL=="event*", SUBSYSTEM=="input", MODE="0640", GROUP="input"
    KERNEL=="uinput", SUBSYSTEM=="misc", MODE="0660", GROUP="input"
  '';
}
