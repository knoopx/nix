{pkgs, ...}:
pkgs.writeShellApplication {
  name = "strip-python-comments";
  runtimeInputs = with pkgs; [python3];
  text = ''
    python ${./strip-python-comments.py} "$@"
  '';
}
