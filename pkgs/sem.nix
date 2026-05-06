{pkgs, ...}:
pkgs.stdenv.mkDerivation rec {
  pname = "sem";
  version = "0.5.4";

  src = pkgs.fetchurl {
    url = "https://github.com/Ataraxy-Labs/sem/releases/download/v${version}/sem-linux-x86_64.tar.gz";
    hash = "sha256-p019mC3ocqY4b5/WyXgi4azPr3n6Kpt7EJL4zT8z3eQ=";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp sem $out/bin/sem
    chmod +x $out/bin/sem
  '';

  meta = {
    description = "Semantic version control CLI — entity-level diff, blame, graph, and impact analysis for code";
    homepage = "https://github.com/Ataraxy-Labs/sem";
    license = with pkgs.lib.licenses; [mit asl20];
    maintainers = [];
    mainProgram = "sem";
    platforms = ["x86_64-linux"];
  };
}
