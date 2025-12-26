{pkgs, ...}: let
  pname = "nfoview";
  version = "2.1";
in
  pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchgit {
      url = "https://github.com/otsaloma/nfoview.git";
      rev = version;
      sha256 = "sha256-ZwYRyo4vTnEqPmISQ1bwcvosmbxjSOyrlYeWkxol/Yk=";
    };

    makeFlags = ["PREFIX=${placeholder "out"}"];

    nativeBuildInputs = with pkgs; [
      gettext
      wrapGAppsHook3
    ];

    buildInputs = with pkgs; [
      cascadia-code
    ];

    preFixup = ''
      gappsWrapperArgs+=(--prefix PYTHONPATH : "${pkgs.python3.withPackages (pp: [pp.pygobject3])}/${pkgs.python3.sitePackages}")
    '';
  }
