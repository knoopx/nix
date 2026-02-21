{pkgs, ...}: let
  inherit (pkgs) lib fetchurl appimageTools makeWrapper;
  pname = "romie";
  version = "0.8.0";
in
  appimageTools.wrapType2 {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/JZimz/romie/releases/download/v${version}/ROMie-${version}-x64.AppImage";
      hash = "sha256-ZfGUXf5CYejsle4pBQ9+k16z965yU3axVMYtItbW4uQ=";
    };

    extraInstallCommands = let
      contents = appimageTools.extractType2 {
        inherit pname version;
        src = fetchurl {
          url = "https://github.com/JZimz/romie/releases/download/v${version}/ROMie-${version}-x64.AppImage";
          hash = "sha256-ZfGUXf5CYejsle4pBQ9+k16z965yU3axVMYtItbW4uQ=";
        };
      };
    in ''
      install -Dm644 ${contents}/ROMie.desktop $out/share/applications/romie.desktop
      substituteInPlace $out/share/applications/romie.desktop \
        --replace-fail 'Exec=ROMie' 'Exec=romie'

      install -Dm644 ${contents}/usr/share/icons/hicolor/512x512/apps/romie.png \
        $out/share/icons/hicolor/512x512/apps/romie.png
    '';

    meta = {
      description = "ROM manager for retro handheld devices";
      longDescription = ''
        ROMie helps you import, organize, and sync your ROM libraries to portable
        retro gaming devices. Create custom playlists (tags) of your favorite games
        and sync them to your device's SD card. ROMie automatically handles the
        correct folder structure for your device.
      '';
      homepage = "https://github.com/JZimz/romie";
      changelog = "https://github.com/JZimz/romie/releases/tag/v${version}";
      license = lib.licenses.mit;
      maintainers = [];
      mainProgram = "romie";
      platforms = ["x86_64-linux"];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    };
  }
