{
  pkgs,
  lib,
  adwaita-colors,
  ...
}: colorScheme:
pkgs.morewaita-icon-theme.overrideAttrs (prev: {
  nativeBuildInputs = (prev.nativeBuildInputs or []) ++ [pkgs.nodePackages.svgo pkgs.lutgen];

  postInstall = ''
    cp -r ${adwaita-colors}/Adwaita-blue/* $out/share/icons/MoreWaita
    find $out/share/icons/MoreWaita -name "*.svg" -type f -print0 | xargs -0 -n1 -P$(nproc) sh -c 'svgo "$1" || true' _
    find $out -name "*.svg" -type f -print0 | xargs -0 -n1 -P$(nproc) sh -c 'lutgen patch --write "$1" -- ${lib.concatStringsSep " " (lib.attrValues colorScheme)} || true' _
  '';
})
