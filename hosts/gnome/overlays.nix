{pkgs, ...}: let
in {
  nixpkgs.overlays = [
    (final: prev: {
      htop = prev.htop.overrideAttrs (origAttrs: {
        postInstall =
          (origAttrs.postInstall or "")
          + "rm $out/share/applications/htop.desktop";
      });
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
