{pkgs, ...}: let
  name = "fuzzy";
in
  pkgs.stdenv.mkDerivation (finalAttrs: {
    inherit name;
    version = "0.1.0";

    src = ./fuzzy.js;
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
