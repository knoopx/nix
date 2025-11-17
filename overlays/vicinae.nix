final: prev: {
  vicinae = prev.vicinae.overrideAttrs (oldAttrs: rec {
    version = "0.16.6";
    src = prev.fetchFromGitHub {
      owner = "vicinaehq";
      repo = "vicinae";
      tag = "v${version}";
      hash = "sha256-mpZj5Nw/rKr97pATMLzO6RlTlag/ZJyvP/Mh6Ifmv2A=";
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
