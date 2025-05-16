{pkgs, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "zorin-icon-themes";
  version = "3.3.1";

  src = pkgs.fetchFromGitHub {
    owner = "ZorinOS";
    repo = "zorin-icon-themes";
    rev = "3.3.2";
    sha256 = "sha256-7hwpRP+6k/N1te6ks/kv2yeK1+1VP5jss2uY0DxuFls=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons

    rm -rf debian
    rm LICENSE README.md

    mv * $out/share/icons

    runHook postInstall
  '';
}
