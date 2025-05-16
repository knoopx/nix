{
  pkgs,
  lib,
  ...
}: let
  pkg = pkgs.python3Packages.buildPythonApplication {
    name = "nix-packages";
    src = ./scripts/nix-packages.py;
    dontUnpack = true;
    pyproject = false;

    nativeBuildInputs = with pkgs; [
      wrapGAppsHook4
      gobject-introspection
    ];

    buildInputs = with pkgs; [
      libadwaita
    ];

    preFixup = ''
      gappsWrapperArgs+=(--prefix PYTHONPATH : "${pkgs.python3.withPackages (p: [
        p.pygobject3
        p.requests
      ])}/${pkgs.python3.sitePackages}")
    '';

    buildPhase = ''
      install -m 755 -D $src $out/bin/nix-packages
    '';

    meta.mainProgram = "nix-packages";
  };
in
  pkgs.symlinkJoin {
    name = "Chat.app";
    paths = [
      pkg
      (pkgs.makeDesktopItem {
        name = "nix-packages";
        desktopName = "Nix Packages";
        exec = lib.getExe pkg;
        icon = "package-x-generic-symbolic";
      })
    ];
  }
