{pkgs, ...}:
pkgs.stdenv.mkDerivation rec {
  pname = "sem";
  version = "0.21.0";

  src = pkgs.fetchurl {
    url = "https://github.com/Ataraxy-Labs/sem/releases/download/v${version}/sem-linux-x86_64.tar.gz";
    hash = "sha256-SgbwGVUq3Te0sGkzCdqvUp6ufykSF9IMKRKUx5Cxa0s=";
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
