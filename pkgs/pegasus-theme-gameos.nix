{pkgs, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "pegasus-theme-gameos";
  src = pkgs.fetchFromGitHub {
    owner = "PlayingKarrde";
    repo = "gameOS";
    rev = "7a5a5223ff7371d0747a7c5d3a3b8f2f5e36b4f2";
    sha256 = "sha256-EBpIe0aw1FO7DzB6F3oAWD5FRLF2iZGtOHllMxuamdc=";
  };
  installPhase = "cp -R ./ $out";
  patches = [
    (pkgs.fetchurl {
      url = "https://github.com/PlayingKarrde/gameOS/compare/7a5a5223ff7371d0747a7c5d3a3b8f2f5e36b4f2...knoopx:gameOS:master.diff";
      sha256 = "sha256-uW1zwsTEywt6BawpPcVvlL7Z2GRnEiqnQEc4KqT1HYo=";
    })
  ];
}
