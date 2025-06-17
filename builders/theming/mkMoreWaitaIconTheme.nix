{
  pkgs,
  adwaita-colors,
  ...
}: colorScheme:
pkgs.morewaita-icon-theme.overrideAttrs (prev: {
  nativeBuildInputs = (prev.nativeBuildInputs or []) ++ [pkgs.nodePackages.svgo];
  postInstall = ''
    cp -r ${adwaita-colors}/Adwaita-blue/* $out/share/icons/MoreWaita
    find $out/share/icons/MoreWaita -name "*.svg" -type f -print0 | xargs -0 -n1 -P$(nproc) sh -c 'svgo "$1" || true' _
  '';
})
