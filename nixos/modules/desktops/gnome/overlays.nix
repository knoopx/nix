{
  pkgs,
  nixgl,
  ...
}: {
  # GNOME 46: triple-buffering-v4-46
  # nixpkgs.config.allowAliases = false;
  nixpkgs.overlays = [
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

    (final: prev: {
      htop = prev.htop.overrideAttrs (oldAttrs: {
        postInstall =
          (oldAttrs.postInstall or "")
          + "rm $out/share/applications/htop.desktop";
      });
    })
  ];
}
