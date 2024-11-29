{
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  name = "skyscraper";
  version = "3.13.1";

  buildInputs = with pkgs; [
    qt5.qmake
    # qt5.qtbase
    kdePackages.wrapQtAppsHook
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp Skyscraper $out/bin/
  '';

  src = fetchTarball {
    url = "https://github.com/Gemba/skyscraper/archive/refs/tags/${version}.zip";
    sha256 = "sha256:1dgka3cwvbixnkpg84kj9rr62njq6kxbrai73k4zw18s4plk1zr3";
  };
}
