final: prev: let
  withoutDesktopIcon = pkg:
    pkg.overrideAttrs (origAttrs: {
      postInstall = ''
        ${origAttrs.postInstall or ""}
        rm -rf $out/share/applications/*.desktop
      '';
    });
in {
  htop = withoutDesktopIcon prev.htop;
  micro = withoutDesktopIcon prev.micro;
  fish = withoutDesktopIcon prev.fish;
  ranger = withoutDesktopIcon prev.ranger;
}
