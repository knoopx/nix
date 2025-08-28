final: prev: {
  zed-editor = prev.zed-editor.overrideAttrs (oldAttrs: rec {
    version = "0.201.5";
    src = prev.fetchFromGitHub {
      owner = "zed-industries";
      repo = "zed";
      tag = "v${version}";
      hash = "sha256-KMUF8k+cJg44Ta5Txb67vbO0zFTU2mKtLODhqbj6xXk=";
    };
  });
}
