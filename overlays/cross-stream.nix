final: prev: {
  cross-stream = prev.rustPlatform.buildRustPackage rec {
    pname = "cross-stream";
    version = "0.13.4";

    src = prev.fetchFromGitHub {
      owner = "cablehead";
      repo = "xs";
      rev = "v0.13.4";
      hash = "sha256-rNkEYGClty7AX+xxMWzIKt6X9GifT1jYgaQ6ol7KHzY=";
    };

    cargoLock = {
      lockFile = src + "/Cargo.lock";
    };

    nativeBuildInputs = [ prev.rustPlatform.cargoSetupHook ]
      ++ [ prev.pkg-config prev.cmake prev.perl ];

    buildInputs = [ prev.sqlite ];

    doCheck = false;

    meta = with prev.lib; {
      description = "An event stream store for personal, local-first use";
      homepage = "https://github.com/cablehead/xs";
      license = licenses.mit;
      mainProgram = "xs";
    };
  };
}