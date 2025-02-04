{pkgs, ...}: let
  json = pkgs.stdenv.mkDerivation {
    name = "pattern-monster.json";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-5R2LUZrf0u98+/va9oPGbWOS5XsiSSlu94UA1JZnxzY=";

    phases = ["buildPhase"];
    buildInputs = with pkgs; [
      cacert
      curl
      nodejs
      jq
    ];
    buildPhase = ''
      curl https://pattern.monster/ \
        | sed -nE 's/data:\s*(.+)\s*,/console.log(JSON.stringify(\1[1].data.data))/p' | node \
        | jq 'map({ (.slug): { mode, width, height, path } }) | add' \
        > $out
    '';

    meta.homepage = "https://github.com/catchspider2002/svelte-svg-patterns/";
  };
in
  builtins.fromJSON (builtins.readFile json)
