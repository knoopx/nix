final: prev: {
  geary = prev.geary.overrideAttrs (old: {
    version = "git";
    src = prev.fetchgit {
      url = "https://gitlab.gnome.org/GNOME/geary.git";
      rev = "0547dc399a60d90b5dbb5ae3fa73f6e590fd98a2";
      sha256 = "sha256-b8hA7GJjazAL0zvGWlOSwqldA3XfkwjyCYYcv6oHU84=";
    };

    postPatch = ''
      chmod +x build-aux/git_version.py
      patchShebangs build-aux/git_version.py
      chmod +x desktop/geary-attach
    '';
  });
}
