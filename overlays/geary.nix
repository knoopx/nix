final: prev: {
  geary = prev.geary.overrideAttrs (old: {
    version = "git";
     src = prev.fetchgit {
       url = "https://gitlab.gnome.org/GNOME/geary.git";
       rev = "a43a1a0275d5fdf7da0005427feb6614ca0de438";
       sha256 = "sha256-4x4moUu+MtkBy+agXlLtclW6QCciMh0Y9H0pdUW+G68=";
     };

    postPatch = ''
      chmod +x build-aux/git_version.py

      patchShebangs build-aux/git_version.py

      chmod +x desktop/geary-attach
    '';
  });
}
