final: prev: {
  helix-unwrapped = prev.helix-unwrapped.overrideAttrs (old: rec {
    version = "git";
    src = final.fetchFromGitHub {
      owner = "helix-editor";
      repo = "helix";
      rev = "0805bc8534bafaa9109f1839f4e771afb32c3391";
      hash = "sha256-utPazkXA5Ef1KELKUDA+tMWkgeLlPhjmA6ma8NAWAe4=";
    };
    patches = [];
    cargoDeps = final.rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
    };
    doCheck = false;
    doInstallCheck = false;
    env =
      old.env
      // {
        HELIX_NIX_BUILD_REV = src.rev;
      };
  });
}
