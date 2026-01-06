final: prev: {
   vicinae = prev.vicinae.overrideAttrs (oldAttrs: rec {
     version = "0.18.1";
     src = prev.fetchFromGitHub {
       owner = "vicinaehq";
       repo = "vicinae";
       tag = "v${version}";
       hash = "sha256-I7FKl8r8xtDfQVo4kkYQEKsxpFhSRZUak67LEHmSyY8=";
     };
      apiDeps = prev.fetchNpmDeps {
        src = "${src}/typescript/api";
        hash = "sha256-UsTpMR23UQBRseRo33nbT6z/UCjZByryWfn2AQSgm6U=";
      };
      extensionManagerDeps = prev.fetchNpmDeps {
        src = "${src}/typescript/extension-manager";
        hash = "sha256-wl8FDFB6Vl1zD0/s2EbU6l1KX4rwUW6dOZof4ebMMO8=";
      };
  });
}
