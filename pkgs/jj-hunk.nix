{pkgs}: let
  pname = "jj-hunk";
  version = "0.5.1";

  src = pkgs.fetchFromGitHub {
    owner = "laulauland";
    repo = "jj-hunk";
    rev = "v${version}";
    sha256 = "sha256-Pe0rLEUMXmq+8eUMmjuu5KvFJ/aN53bTQ6/1rE2YcT0=";
  };
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-tO4oGY92AieYb1SY3ylWSkOlcIKadbZLKOY6nTzXo48=";

    doCheck = false;

    meta = {
      description = "Programmatic hunk selection for jj (Jujutsu)";
      homepage = "https://github.com/laulauland/jj-hunk";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = "jj-hunk";
    };
  }
