final: prev: {
  helix-unwrapped = prev.helix-unwrapped.overrideAttrs (old: rec {
    version = "git";
    src = final.fetchFromGitHub {
      owner = "helix-editor";
      repo = "helix";
      rev = "a05c151bb6e8e9c65ec390b0ae2afe7a5efd619b";
      hash = "sha256-RFSzGAcB0mMg/02ykYfTWXzQjLFu2CJ4BkS5HZ/6pBo=";
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
