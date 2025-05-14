{pkgs, ...}:
pkgs.writeShellApplication {
  name = "raise-or-open-url";
  runtimeInputs = with pkgs; [jq brotab];
  text = builtins.readFile ./scripts/raise-or-open-url.sh;
}
