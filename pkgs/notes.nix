{pkgs, ...}:
pkgs.python3Packages.buildPythonApplication {
  name = "notes";
  src = ./scripts/notes.py;
  dontUnpack = true;
  pyproject = false;

  nativeBuildInputs = with pkgs; [
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = with pkgs; [
    libadwaita
    gtksourceview5
    webkitgtk_6_0
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PYTHONPATH : "${pkgs.python3.withPackages (p: [
      p.pygobject3
      p.markdown2
    ])}/${pkgs.python3.sitePackages}")
  '';

  buildPhase = ''
    install -m 755 -D $src $out/bin/notes
  '';
}
