final: prev: {
  vicinae = prev.vicinae.overrideAttrs (oldAttrs: rec {
    version = "0.16.7";
    src = prev.fetchFromGitHub {
      owner = "vicinaehq";
      repo = "vicinae";
      tag = "v${version}";
      hash = "sha256-/CjdThQEmaLpI2gau46TuaPt3r79CIHY+Am10GynkYQ=";
    };
    apiDeps = prev.fetchNpmDeps {
      src = "${src}/typescript/api";
      hash = "sha256-4OgVCnw5th2TcXszVY5G9ENr3/Y/eR2Kd45DbUhQRNk=";
    };
    extensionManagerDeps = prev.fetchNpmDeps {
      src = "${src}/typescript/extension-manager";
      hash = "sha256-krDFHTG8irgVk4a79LMz148drLgy2oxEoHCKRpur1R4=";
    };
  });
}
