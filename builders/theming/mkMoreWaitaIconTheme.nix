{
  pkgs,
  adwaita-colors,
  ...
}: colorScheme:
pkgs.morewaita-icon-theme.overrideAttrs (prev: {
  postInstall = ''
    cp -r ${adwaita-colors}/Adwaita-blue/* $out/share/icons/MoreWaita
  '';
})
