{pkgs}: let
  pname = "gritql";
  version = "0.1.0-alpha.1743007075";

  src = pkgs.fetchgit {
    url = "https://github.com/biomejs/gritql";
    rev = "v${version}";
    sha256 = "sha256-ru8XnXiwwrlrGFtj8kIXUGBS6jnazLIQklZotTPItSw=";
    fetchSubmodules = true;
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-tvwxoqPpVoR7oZJuVfssrwica2dVVs2DyvD9mzW+NwU=";

    nativeBuildInputs = with pkgs; [
      perl
      pkg-config
    ];

    postPatch = ''
      # Patch out problematic feature flags that cause cargo-auditable to fail
      # due to Rust edition 2024 dep: syntax in marzano dependencies
      sed -i 's/default = \["marzano-cli\/default", "grit_tracing"\]/default = ["marzano-cli\/default"]/' crates/cli_bin/Cargo.toml
    '';

    doCheck = false;

    meta = {
      description = "A declarative query language for searching and modifying source code";
      homepage = "https://github.com/biomejs/gritql";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "grit";
    };
  }
