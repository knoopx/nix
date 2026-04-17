{pkgs}: let
  pname = "dawn";
  version = "0.1.3";

  src = pkgs.fetchFromGitHub {
    owner = "andrewmd5";
    repo = "dawn";
    rev = "v${version}";
    hash = "sha256-A3wsBHrlW7sKmDtDrmmToNTtPHekbNk/wii9fjdZgcM=";
    fetchSubmodules = true;
  };
in
  pkgs.stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      pkgs.cmake
      pkgs.pkg-config
      pkgs.makeWrapper
    ];

    buildInputs = [
      pkgs.curl
    ];

    cmakeFlags = [
      "-DENABLE_ASAN=OFF"
      "-DENABLE_UBSAN=OFF"
      "-DUSE_LIBAI=OFF"
    ];

    dontStrip = true;

    installPhase = ''
      mkdir -p $out/bin
      cp dawn $out/bin/dawn
    '';

    meta = {
      description = "A distraction-free writing environment; draft anything, write now.";
      homepage = "https://github.com/andrewmd5/dawn";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "dawn";
    };
  }
