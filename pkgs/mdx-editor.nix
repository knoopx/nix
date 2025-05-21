{
  pkgs,
  lib,
  ...
}: let
  deps = pkgs.stdenv.mkDerivation {
    name = "mdx-editor-deps";
    dontUnpack = true;
    nativeBuildInputs = with pkgs; [
      bun
    ];

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-QfcaPTdm2V7p/DFdZUjrne97JbXZMnDbZ+EGCfwaBsU=";

    buildPhase = ''
      bun add vite react react-dom @mdxeditor/editor
      mv node_modules $out
    '';
  };

  assets = pkgs.stdenv.mkDerivation {
    name = "mdx-editor-assets";
    src = ./scripts/mdx-editor;
    nativeBuildInputs = with pkgs; [
      bun
    ];

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-ECCgyI/z3ZqUoB4JKxbDFe/O6YlMpzfuFscry2MAFEM=";

    buildPhase = ''
      cp -r ${deps} node_modules
      bun node_modules/vite/bin/vite.js build
      mv dist $out
    '';
  };

  pkg = pkgs.python3Packages.buildPythonApplication {
    name = "mdx-editor";
    src = ./scripts/mdx-editor.py;
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
      install -m 755 -D $src $out/bin/mdx-editor
      cp -r ${assets}/* $out/bin/
      substituteInPlace $out/bin/index.html --replace-fail "/assets/" "./assets/"
    '';

    meta.mainProgram = "mdx-editor";
  };
in
  pkgs.symlinkJoin {
    name = "mdx-editor";
    paths = [
      pkg
      (pkgs.makeDesktopItem {
        name = "mdx-editor";
        desktopName = "Notes";
        exec = lib.getExe pkg;
        icon = "document-new-symbolic";
      })
    ];
  }
