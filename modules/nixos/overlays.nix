{pkgs, ...}: let
  withoutDesktopIcon = pkg:
    pkg.overrideAttrs (origAttrs: {
      postInstall = ''
        ${origAttrs.postInstall or ""}
        rm -rf $out/share/applications/*.desktop
      '';
    });
in {
  nixpkgs.overlays = [
    (final: prev: {
      htop = withoutDesktopIcon prev.htop;
      btop = withoutDesktopIcon prev.btop;
      micro = withoutDesktopIcon prev.micro;
      fish = withoutDesktopIcon prev.fish;
      ranger = withoutDesktopIcon prev.ranger;
      visidata = withoutDesktopIcon prev.visidata;

      plexamp = prev.plexamp.overrideAttrs (origAttrs: {
        buildCommand =
          origAttrs.buildCommand
          + ''
            rm $out/bin/plexamp
            mv $out/bin/.plexamp-wrapped $out/bin/plexamp
            wrapProgram "$out/bin/plexamp" --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --disable-features=WaylandFractionalScaleV1"
          '';
      });
    })
  ];
}
