final: prev: {
  nvidia-container-toolkit = prev.nvidia-container-toolkit.overrideAttrs (oldAttrs: rec {
    version = "1.18.0";
    src = prev.fetchFromGitHub {
      owner = "NVIDIA";
      repo = "nvidia-container-toolkit";
      rev = "v${version}";
      hash = "sha256-1l1d03fs83bglpmqj1pgccvqpi4m6lcq9zc719z2m265djsq43sg";
    };
  });
}