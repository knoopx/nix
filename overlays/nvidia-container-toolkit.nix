final: prev: {
  nvidia-container-toolkit = prev.nvidia-container-toolkit.overrideAttrs (oldAttrs: rec {
    version = "1.18.0";
    src = prev.fetchFromGitHub {
      owner = "NVIDIA";
      repo = "nvidia-container-toolkit";
      rev = "v${version}";
      hash = "sha256-VQcuN+LU7iljpSWrmLBHX67esEQN1HYNPj5cLxUB7dI=";
    };

    postPatch = ''
      substituteInPlace internal/config/config.go \
        --replace-fail /usr/bin/nvidia-container-runtime-hook "$tools/bin/nvidia-container-runtime-hook" \
        --replace-fail '/sbin/ldconfig' '${prev.lib.getBin prev.glibc}/sbin/ldconfig'
      substituteInPlace cmd/nvidia-ctk-installer/toolkit/toolkit.go \
        --replace-fail '/sbin/ldconfig' '${prev.lib.getBin prev.glibc}/sbin/ldconfig'
      substituteInPlace cmd/nvidia-cdi-hook/update-ldcache/update-ldcache.go \
        --replace-fail '/sbin/ldconfig' '${prev.lib.getBin prev.glibc}/sbin/ldconfig'
    '';
  });
}
