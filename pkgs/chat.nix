{
  pkgs,
  lib,
  ...
}: let
  md2html = pkgs.callPackage ./md2html.nix {};

  pkg = pkgs.python3Packages.buildPythonApplication {
    name = "chat";
    src = ./scripts/chat.py;
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
      gappsWrapperArgs+=(--prefix PATH : "${md2html}/bin" --prefix PYTHONPATH : "${pkgs.python3.withPackages (p: [
        p.pygobject3
        p.openai
      ])}/${pkgs.python3.sitePackages}")
    '';

    buildPhase = ''
      install -m 755 -D $src $out/bin/chat
    '';

    meta.mainProgram = "chat";
  };
in
  pkgs.symlinkJoin {
    name = "chat";
    paths = [
      pkg
      (pkgs.makeDesktopItem {
        name = "chat";
        desktopName = "Chat";
        exec = lib.getExe pkg;
        icon = "chat-message-new-symbolic";
      })
    ];
  }
