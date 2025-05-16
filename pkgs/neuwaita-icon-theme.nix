{
  pkgs,
  neuwaita,
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  name = "Neuwaita";
  src = neuwaita;
  installPhase = ''
    mkdir -p $out/share/icons/Neuwaita/{scalable,symbolic}/{apps,devices,legacy,mimetypes,places,status}
    cp -r scalable/* $out/share/icons/Neuwaita/scalable/
    cp -r index.theme $out/share/icons/Neuwaita/index.theme
    substituteInPlace $out/share/icons/Neuwaita/index.theme --replace-fail "Inherits=Adwaita, hicolor, breeze" "Inherits=MoreWaita,Adwaita,hicolor,breeze"
  '';
}
