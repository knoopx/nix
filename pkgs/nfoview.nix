{
  pkgs,
  nix-update-script,
  ...
}: let
  pname = "nfoview";
  version = "2.0.1";
in
  pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchgit {
      url = "https://github.com/otsaloma/nfoview";
      rev = version;
      sha256 = "sha256-l7Aq/i5OS11wbuSDbRgpRyxPl5H+7v0Phn4utlF9BN4=";
    };

    makeFlags = ["PREFIX=${placeholder "out"}"];

    nativeBuildInputs = with pkgs; [
      gettext
      wrapGAppsHook4
    ];

    buildInputs = with pkgs; [
      cascadia-code
    ];

    preFixup = ''
      gappsWrapperArgs+=(--prefix PYTHONPATH : "${pkgs.python3.withPackages (pp: [pp.pygobject3])}/${pkgs.python3.sitePackages}")
    '';

    passthru.updateScript = nix-update-script {};
  }
