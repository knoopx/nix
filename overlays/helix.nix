final: prev: {
  helix-unwrapped = prev.helix-unwrapped.overrideAttrs (old: rec {
    version = "git";
    src = final.fetchFromGitHub {
      owner = "helix-editor";
      repo = "helix";
      rev = "eb49c5e4e07b4d7c63b88371d3a6e542a140c6b3";
      hash = "sha256-Qa0if6Rp9/ELdRVlT93fGwjKF4oEeKaY+ML+GY/fYSM=";
    };
    patches = [ ];
    cargoDeps = final.rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
    };
    doCheck = false;
    doInstallCheck = false;
    env =
      old.env // {
        HELIX_NIX_BUILD_REV = src.rev;
      };
  });
}
