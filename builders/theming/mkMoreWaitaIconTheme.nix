{
  pkgs,
  adwaita-colors,
  ...
}: _colorScheme:
pkgs.morewaita-icon-theme.overrideAttrs (prev: {
  postInstall = let
    color = "blue";
  in ''
    # Copy colored app icons
    mkdir -p $out/share/icons/MoreWaita/scalable/apps
    cp ${adwaita-colors}/apps/${color}/*.svg $out/share/icons/MoreWaita/scalable/apps/

    # Copy colored mimetype icons
    mkdir -p $out/share/icons/MoreWaita/scalable/mimetypes
    cp ${adwaita-colors}/mimetypes/${color}/*.svg $out/share/icons/MoreWaita/scalable/mimetypes/

    # Copy custom folder icons
    mkdir -p $out/share/icons/MoreWaita/scalable/places
    cp ${adwaita-colors}/folders/*.svg $out/share/icons/MoreWaita/scalable/places/

    gtk-update-icon-cache -f $out/share/icons/MoreWaita
  '';
})
