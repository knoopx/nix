{pkgs, ...}:
pkgs.writeShellApplication {
  name = "strip-python-comments";
  runtimeInputs = with pkgs; [python312];
  text = ''
    python ${./strip-python-comments.py} "$@"
  '';
}
