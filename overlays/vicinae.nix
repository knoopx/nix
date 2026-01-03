final: prev: {
  vicinae = prev.vicinae.overrideAttrs (oldAttrs: rec {
    version = "0.18.0";
    src = prev.fetchFromGitHub {
      owner = "vicinaehq";
      repo = "vicinae";
      tag = "v${version}";
      hash = "sha256-ApMcDKe+6uYb2M+UL8SWW8M1S5bmT8EI5uOChLxzWqs=";
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
