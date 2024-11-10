{
  pkgs,
  writeTextFile,
  nix-update-script,
  ...
}: let
  pname = "zen";
  version = "1.0.1-a.18";

  runtimeLibs = with pkgs;
    [
      libGL
      libGLU
      libevent
      libffi
      libjpeg
      libpng
      libstartup_notification
      libvpx
      libwebp
      stdenv.cc.cc
      fontconfig
      libxkbcommon
      zlib
      freetype
      gtk3
      libxml2
      dbus
      xcb-util-cursor
      alsa-lib
      libpulseaudio
      pango
      atk
      cairo
      gdk-pixbuf
      glib
      udev
      libva
      mesa
      libnotify
      cups
      pciutils
      ffmpeg
      libglvnd
      pipewire
    ]
    ++ (with pkgs.xorg; [
      libxcb
      libX11
      libXcursor
      libXrandr
      libXi
      libXext
      libXcomposite
      libXdamage
      libXfixes
      libXScrnSaver
    ]);

  desktopFile = writeTextFile {
    name = "${pname}.desktop";
    text = ''
      [Desktop Entry]
      Name=Zen
      Exec=${pname} %u
      Icon=${pname}
      Type=Application
      MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;application/x-xpinstall;application/pdf;application/json;
      StartupWMClass=zen-alpha
      Categories=Network;WebBrowser;
      StartupNotify=true
      Terminal=false
      X-MultipleArgs=false
      Keywords=Internet;WWW;Browser;Web;Explorer;
      Actions=new-window;new-private-window;profilemanager;

      [Desktop Action new-window]
      Name=Open a New Window
      Exec=zen %u

      [Desktop Action new-private-window]
      Name=Open a New Private Window
      Exec=zen --private-window %u

      [Desktop Action profilemanager]
      Name=Open the Profile Manager
      Exec=zen --ProfileManager %u
    '';
  };
in
  pkgs.stdenv.mkDerivation rec {
    inherit pname version;

    src = pkgs.fetchzip {
      url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-specific.tar.bz2";
      sha256 = "sha256-b6XXIVmIEsCt6HsSVbN5hmm4YgpsYbVRjrAdjjpH39g=";
    };

    nativeBuildInputs = with pkgs;
      [
        autoPatchelfHook
        makeWrapper
        copyDesktopItems
        wrapGAppsHook
      ]
      ++ runtimeLibs;

    installPhase = ''
      mkdir -p $out/bin
      cp -r $src/* $out/bin
      rm $out/bin/{zen-bin,updater,updater.ini,glxtest,vaapitest}
      install -D ${desktopFile} $out/share/applications/${pname}.desktop
      install -D $src/browser/chrome/icons/default/default128.png $out/share/pixmaps/${pname}.png
    '';

    fixupPhase = ''
      wrapProgram $out/bin/zen --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
                      --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    '';

    meta.mainProgram = "zen";
    passthru.updateScript = nix-update-script {};
  }
