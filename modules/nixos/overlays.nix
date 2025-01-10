{...}: let
in {
  nixpkgs.overlays = [
    (final: prev: {
      htop = prev.htop.overrideAttrs (origAttrs: {
        postInstall = "rm $out/share/applications/htop.desktop";
      });

      btop = prev.btop.overrideAttrs (origAttrs: {
        postInstall = "rm $out/share/applications/btop.desktop";
      });

      micro = prev.micro.overrideAttrs (origAttrs: {
        postInstall =
          origAttrs.postInstall + "rm $out/share/applications/micro.desktop";
      });

      plexamp = prev.plexamp.overrideAttrs (origAttrs: {
        extraInstallCommands =
          (origAttrs.extraInstallCommands or "")
          + ''
            rm $out/bin/plexamp
            mv $out/bin/.plexamp-wrapped $out/bin/plexamp
            wrapProgram "$out/bin/plexamp" --add-flags "--disable-features=WaylandFractionalScaleV1"
          '';
      });
    })
  ];
}
