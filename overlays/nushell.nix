final: prev:
# Pin nushell to 0.116.0 (https://www.nushell.sh/blog/2026-09-26-nushell_v0_116_0.html).
#
# buildRustPackage computes the cargo vendor (cargoDeps) eagerly from the
# `cargoHash` it is called with, so a plain `overrideAttrs` on prev.nushell
# cannot change the vendor hash — the old 0.115.1 vendor derivation stays
# baked in. Re-invoke the builder with the full attr set (mirroring
# nixpkgs pkgs/by-name/nu/nushell/package.nix) so version/src/cargoHash all
# take effect. doCheck is off to skip the slow `cargo test` phase.
{
  nushell = (prev.rustPlatform.buildRustPackage) (finalAttrs: {
    pname = "nushell";
    version = "0.116.0";

    src = prev.fetchFromGitHub {
      owner = "nushell";
      repo = "nushell";
      tag = finalAttrs.version;
      hash = "sha256-xSV4v7VJ3vd39a4hAywjo7hXtwrB598DtMOsYWqfIFA=";
    };

    cargoHash = "sha256-SL+ARL+fFFy8R3IW6IYPcbS+mAXb+Mzp4v3y5uv7wAI=";

    nativeBuildInputs = [
      prev.pkg-config
    ]
    ++ prev.lib.optionals prev.stdenv.hostPlatform.isLinux [ prev.python3 ]
    ++ prev.lib.optionals prev.stdenv.hostPlatform.isDarwin [ prev.rustPlatform.bindgenHook ];

    buildInputs = [
      prev.zstd
    ]
    ++ prev.lib.optionals prev.stdenv.hostPlatform.isDarwin [ prev.zlib ]
    ++ prev.lib.optionals prev.stdenv.hostPlatform.isLinux [ prev.libx11 ]
    ++ prev.lib.optionals prev.stdenv.hostPlatform.isDarwin [
      prev.nghttp2
      prev.libgit2
    ];

    buildNoDefaultFeatures = false;
    buildFeatures = [ ];

    preCheck = ''
      export NU_TEST_LOCALE_OVERRIDE="en_US.UTF-8"
    '';

    doCheck = false;

    meta = {
      description = "Modern shell written in Rust";
      homepage = "https://www.nushell.sh/";
      license = prev.lib.licenses.mit;
      maintainers = with prev.lib.maintainers; [
        johntitor
        joaquintrinanes
        ryan4yin
      ];
      mainProgram = "nu";
    };
  });
}
