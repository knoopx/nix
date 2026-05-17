{pkgs, ...}:
pkgs.stdenv.mkDerivation rec {
  pname = "sem";
  version = "0.5.5";

  src = pkgs.fetchurl {
    url = "https://github.com/Ataraxy-Labs/sem/releases/download/v${version}/sem-linux-x86_64.tar.gz";
    hash = "sha256-91bnMrYSh2oNhGBmGAEAejTVYRNrvLJRU0llYRZaTo8=";
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
