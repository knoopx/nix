final: prev: {
  geary = prev.geary.overrideAttrs (old: {
    version = "git";
    src = prev.fetchFromGitHub {
      owner = "GNOME";
      repo = "geary";
      rev = "e1a5e4503a4ad8e93da22eca6db54dac6b47f8d3";
      hash = "sha256-G3VEs3cU7ifGYYclW+dtAuDDgKrcNphR766jM08csnE=";
    };

    postPatch = ''
      chmod +x build-aux/git_version.py

      patchShebangs build-aux/git_version.py

      chmod +x desktop/geary-attach
    '';
  });
}
