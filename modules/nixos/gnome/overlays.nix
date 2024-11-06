_: {
  nixpkgs.overlays = [
    # mypkgs
    (final: prev: {
      htop = prev.htop.overrideAttrs (origAttrs: {
        postInstall = "rm $out/share/applications/htop.desktop";
      });

      micro = prev.micro.overrideAttrs (origAttrs: {
        postInstall =
          origAttrs.postInstall + "rm $out/share/applications/micro.desktop";
      });

      # TODO: remove me once fixed
      _7zz = prev._7zz.override {useUasm = true;};
    })

    # (final: prev: {
    #   gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
    #     mutter = gnomePrev.mutter.overrideAttrs (old: {
    #       src = pkgs.fetchFromGitLab {
    #         domain = "gitlab.gnome.org";
    #         owner = "vanvugt";
    #         repo = "mutter";
    #         rev = "triple-buffering-v4-46";
    #         hash = "sha256-nz1Enw1NjxLEF3JUG0qknJgf4328W/VvdMjJmoOEMYs=";
    #       };
    #     });
    #   });
    # })
  ];
}
