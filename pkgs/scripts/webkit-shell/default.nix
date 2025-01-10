{pkgs, ...}: let
  name = "webkit-shell";
in
  # https://github.com/gircore/gir.core/blob/main/src/Samples/WebKit-6.0/JavascriptCallback/Program.cs
  # https://github.com/johnfactotum/quick-lookup
  pkgs.stdenv.mkDerivation (finalAttrs: {
    inherit name;
    version = "0.1.0";

    src = ./webkit-shell.js;
    dontUnpack = true;

    nativeBuildInputs = with pkgs; [
      pkg-config
      gobject-introspection
      wrapGAppsHook4
    ];

    buildInputs = with pkgs; [
      libadwaita
      gjs
      webkitgtk_6_0
      glib-networking
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${name}
    '';
  })
