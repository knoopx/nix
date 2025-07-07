final: prev: {
  vscode =
    (prev.vscode.overrideAttrs (oldAttrs: {
      version = "latest";
      src = builtins.fetchTarball {
        url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
        sha256 = "sha256:099vnvh9j163n9yfsqiasy2aq6jhh77ls964017mph1a84njmz7v";
      };
      postInstall = ''
        ln -s $out/bin/code-insiders $out/bin/code
      '';
    })).override {
      isInsiders = true;
    };
}
