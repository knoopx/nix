final: prev: {
  http-nu = prev.rustPlatform.buildRustPackage rec {
    pname = "http-nu";
    version = "0.17.2";

    src = prev.fetchFromGitHub {
      owner = "cablehead";
      repo = "http-nu";
      tag = "v${version}";
      hash = "sha256-6lwc0cMTdBOY5tpBfM4RDczXFbkDppNNftQ5snPrJZA=";
    };

    cargoHash = "sha256-RkwvHB6IanfAoQVdeDqdRR+mvClj7KZufpy+kXGN/yE=";

    doCheck = false;

    meta = {
      description = "Serve a Nushell closure over HTTP";
      homepage = "https://github.com/cablehead/http-nu";
      license = prev.lib.licenses.mit;
      mainProgram = "http-nu";
    };
  };
}