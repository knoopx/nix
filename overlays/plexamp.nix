final: prev: {
  plexamp = prev.plexamp.overrideAttrs (origAttrs: {
    buildCommand =
      origAttrs.buildCommand
      + ''
        rm $out/bin/plexamp
        mv $out/bin/.plexamp-wrapped $out/bin/plexamp
        wrapProgram "$out/bin/plexamp" --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --disable-features=WaylandFractionalScaleV1"
      '';
  });
}
