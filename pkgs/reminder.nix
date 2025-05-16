{
  pkgs,
  lib,
  ...
}: let
  pkg = pkgs.python3Packages.buildPythonApplication {
    name = "reminder";
    src = ./scripts/reminder.py;
    dontUnpack = true;
    pyproject = false;

    nativeBuildInputs = with pkgs; [
      wrapGAppsHook4
      gobject-introspection
    ];

    buildInputs = with pkgs; [
      libadwaita
      evolution-data-server
    ];

    preFixup = ''
      gappsWrapperArgs+=(--prefix PYTHONPATH : "${pkgs.python3.withPackages (p: [
        p.pygobject3
        p.dateparser
      ])}/${pkgs.python3.sitePackages}")
    '';

    buildPhase = ''
      install -m 755 -D $src $out/bin/reminder
    '';

    meta.mainProgram = "reminder";
  };
in
  pkgs.symlinkJoin {
    name = "reminder";
    paths = [
      pkg
      (pkgs.makeDesktopItem {
        name = "reminder";
        desktopName = "Reminder";
        exec = lib.getExe pkg;
        icon = "preferences-system-time-symbolic";
      })
    ];
  }
