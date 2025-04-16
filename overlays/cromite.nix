final: prev: let
  inherit
    (prev)
    makeDesktopItem
    qt6
    lib
    xdg-utils
    ;
in {
  cromite =
    prev.cromite.overrideAttrs
    {
      desktopItems = [
        (makeDesktopItem {
          name = "cromite";
          exec = "cromite %U";
          icon = "google-chrome";
          startupWMClass = "chromium-browser";
          genericName = "Cromite";
          desktopName = "Cromite";
          categories = [
            "Application"
            "Network"
            "WebBrowser"
          ];
        })
      ];
      # --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addDriverRunpath.driverLink}/share" \

      postFixup = ''
        rm $out/bin/cromite
        makeWrapper $out/share/cromite/chrome $out/bin/cromite \
          --prefix QT_PLUGIN_PATH  : "${qt6.qtbase}/lib/qt-6/plugins" \
          --prefix QT_PLUGIN_PATH  : "${qt6.qtwayland}/lib/qt-6/plugins" \
          --prefix NIXPKGS_QT6_QML_IMPORT_PATH : "${qt6.qtwayland}/lib/qt-6/qml" \
          --prefix LD_LIBRARY_PATH : "$rpath" \
          --prefix PATH            : "$binpath" \
          --suffix PATH            : "${lib.makeBinPath [xdg-utils]}" \
          --set CHROME_WRAPPER  "cromite" \
          --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --disable-features=WaylandFractionalScaleV1"
      '';
    };
}
