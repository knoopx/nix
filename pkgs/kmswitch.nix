{ pkgs, lib, }:
# KMSwitch: software KVM (keyboard+mouse) over the LAN, in dependency-free Rust.
# Prebuilt x86-64 Linux binary (zero third-party deps; dynamically linked to glibc).
# Uses /dev/input (capture) + /dev/uinput (injection), so it is compositor-agnostic
# (works on niri, unlike deskflow's Wayland backend).
pkgs.runCommand "kmswitch" {
  meta.mainProgram = "kmswitch";
} ''
  mkdir -p $out/bin
  cp ${pkgs.fetchurl {
    url    = "https://github.com/ToxicOrca/keyboard-mouse-switch/releases/download/v0.1.0/kmswitch-linux-x64";
    sha256 = "67c3d3a4efadc62bcdb3ea84eeb59ba130f25d350423149aadb72cbd8f7e187b";
  }} $out/bin/kmswitch
  chmod +x $out/bin/kmswitch
''
