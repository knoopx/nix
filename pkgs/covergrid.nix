{pkgs, ...}:
pkgs.python3Packages.buildPythonApplication {
  pname = "covergrid";
  version = "3.2";
  pyproject = false;
  src = fetchGit {
    url = "https://gitlab.com/coderkun/mcg.git";
    rev = "75b99e5820f0f28f5cfb52507c9fb20f15b454fb";
  };

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = with pkgs; [
    glib
    gtk4
    libadwaita
    gobject-introspection
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    pygobject3
    dateutil
  ];
}
