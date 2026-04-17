{
  lib,
  pkgs,
  ...
}:
with lib; let
  desktopEntryFromPackage = package: let
    applicationsPath = "${package}/share/applications";
    entries =
      if builtins.pathExists applicationsPath
      then builtins.attrNames (builtins.readDir applicationsPath)
      else [];
    desktopEntries = sort lessThan (builtins.filter (name: hasSuffix ".desktop" name) entries);
    mainProgram = toLower (package.meta.mainProgram or "");

    exactMainProgram = builtins.filter (name: toLower name == "${mainProgram}.desktop") desktopEntries;
    matchingMainProgramNoAutorun =
      builtins.filter
      (name: hasInfix mainProgram (toLower name) && !(hasInfix "autorun" (toLower name)))
      desktopEntries;
    matchingMainProgram = builtins.filter (name: hasInfix mainProgram (toLower name)) desktopEntries;
  in
    if exactMainProgram != []
    then builtins.head exactMainProgram
    else if matchingMainProgramNoAutorun != []
    then builtins.head (sort (a: b: builtins.stringLength a < builtins.stringLength b) matchingMainProgramNoAutorun)
    else if matchingMainProgram != []
    then builtins.head (sort (a: b: builtins.stringLength a < builtins.stringLength b) matchingMainProgram)
    else if desktopEntries != []
    then builtins.head desktopEntries
    else "${getName package}.desktop";

  mkAppModule = {description}: {config, ...}: {
    options = {
      package = mkOption {
        type = types.package;
        inherit description;
      };
      desktopEntry = mkOption {
        type = types.str;
        default = desktopEntryFromPackage config.package;
        description = "Desktop entry derived from package metadata/files";
      };
    };
  };
in {
  options.defaults.apps = {
    browser = mkOption {
      type = types.submodule (mkAppModule {description = "Default browser package";});
      description = "Default browser";
    };
    terminal = mkOption {
      type = types.submodule (mkAppModule {description = "Default terminal package";});
      description = "Default terminal";
    };
    editor = mkOption {
      type = types.submodule (mkAppModule {description = "Default editor package";});
      description = "Default editor";
    };
    fileManager = mkOption {
      type = types.submodule (mkAppModule {description = "Default file manager package";});
      description = "Default file manager";
    };
    imageViewer = mkOption {
      type = types.submodule (mkAppModule {description = "Default image viewer package";});
      description = "Default image viewer";
    };
    videoPlayer = mkOption {
      type = types.submodule (mkAppModule {description = "Default video player package";});
      description = "Default video player";
    };
    musicPlayer = mkOption {
      type = types.submodule (mkAppModule {description = "Default music player package";});
      description = "Default music player";
    };
    pdfViewer = mkOption {
      type = types.submodule (mkAppModule {description = "Default PDF viewer package";});
      description = "Default PDF viewer";
    };
    archiveManager = mkOption {
      type = types.submodule (mkAppModule {description = "Default archive manager package";});
      description = "Default archive manager";
    };
  };

  config.defaults.apps = {
    browser.package = pkgs.browser;
    browser.desktopEntry = "firefox-esr.desktop";

    terminal.package = pkgs.terminal;
    terminal.desktopEntry = "kitty.desktop";

    editor.package = pkgs.editor;
    editor.desktopEntry = "helix.desktop";

    fileManager.package = pkgs.file-manager;
    fileManager.desktopEntry = "org.gnome.Nautilus.desktop";

    imageViewer.package = pkgs.image-viewer;
    imageViewer.desktopEntry = "org.gnome.eog.desktop";

    videoPlayer.package = pkgs.video-player;
    videoPlayer.desktopEntry = "mpv.desktop";

    musicPlayer.package = pkgs.music-player;
    musicPlayer.desktopEntry = "org.gnome.Decibels";

    pdfViewer.package = pkgs.pdf-viewer;
    pdfViewer.desktopEntry = "org.gnome.Evince.desktop";

    archiveManager.package = pkgs.archive-manager;
    archiveManager.desktopEntry = "org.gnome.FileRoller.desktop";
  };
}
