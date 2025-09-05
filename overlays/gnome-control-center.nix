final: prev: {
  gnome-control-center = prev.gnome-control-center.overrideAttrs {
    postInstall = ''
      wrapProgram $out/bin/gnome-control-center \
        --set XDG_CURRENT_DESKTOP GNOME
    '';
  };
}
