{pkgs, ...}: let
  shaml = pkgs.callPackage ../shamls {};
in
  pkgs.writeShellApplication {
    name = "launcher";
    runtimeInputs = with pkgs; [ghostty shaml];
    text = ''
      ghostty --window-width=120 --window-height=40 --window-decoration=false -e navi
    '';
  }
