{pkgs, ...}:
pkgs.writeShellApplication {
  name = "shamls";
  runtimeInputs = with pkgs; [
    (ruby.withPackages (ps: with ps; [colored activesupport]))
  ];
  text = ''
    ruby ${./shamls.rb} "$@"
  '';
}
