{ pkgs }:

# wvkbd built with the deskintl layout set (desktop/laptop/tablet layouts,
# US-International English). nixpkgs only ships the default mobintl layout.
pkgs.wvkbd.overrideAttrs (final: prev: {
  makeFlags = [ "LAYOUT=deskintl" ];
  meta = prev.meta // { mainProgram = "wvkbd-deskintl"; };
})
