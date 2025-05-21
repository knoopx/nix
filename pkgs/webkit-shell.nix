{
  pkgs,
  lib,
  ...
}:
pkgs.python3Packages.buildPythonApplication {
  name = "webkit-shell";
  src = ./scripts/webkit-shell.py;
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
    glib-networking
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PYTHONPATH : "${pkgs.python3.withPackages (p: [
      p.pygobject3
    ])}/${pkgs.python3.sitePackages}")
  '';

  buildPhase = ''
    install -m 755 -D $src $out/bin/webkit-shell
  '';

  meta.mainProgram = "webkit-shell";
}
