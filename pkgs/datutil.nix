{
  pkgs,
  stdenv,
  ...
}: let
  pname = "datutil";
  version = "2.46";
  name = "${pname}-${version}";
in
  stdenv.mkDerivation
  {
    inherit name;
    dontUnpack = true;
    sourceRoot = ".";
    src = pkgs.fetchurl {
      url = "https://hitchhiker-linux.org/pub/stable/arch/x86_64/packages/DatUtil-${version}.tgz";
      sha256 = "sha256-raLkq1n0kQ9iPUqESLmGYd707W3zzq8+laaZszCVsro=";
    };

    installPhase = ''
      ${pkgs.gnutar}/bin/tar xf $src -C $out
    '';
  }
