{pkgs, ...} @ args: {
  fuzzy = pkgs.callPackage ./fuzzy args;
  webkit-shell = pkgs.callPackage ./webkit-shell args;
  shttp = pkgs.callPackage ./shttp args;
  launcher = pkgs.callPackage ./launcher args;
  ollamark = pkgs.callPackage ./ollamark args;
  shamls = pkgs.callPackage ./shamls args;
  importantize = pkgs.callPackage ./importantize.nix args;

  repl-jq = pkgs.writeShellApplication {
    name = "repl-jq";
    runtimeInputs = with pkgs; [fzf jq];
    text = ''
      echo "" | fzf-tmux -p '80%' --print-query --preview "echo ''${1} | jq {q}"
    '';
  };
}
