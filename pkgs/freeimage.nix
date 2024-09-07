{pkgs, ...}: let
  version = "3.18.0";
in {
  inherit version;
  pkgname = "freeimage";
  pkgrel = "22";
  src = pkgs.fetchzip {
    url = "https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/${version}/FreeImage${builtins.replaceStrings ["."] [""] version}.zip";
    sha256 = "sha256-Ply+qzYs0CRLyUxgS8xoXTOOqLVnK2u5ArksgEvOikA=";
  };

  patches = [
    (pkgs.fetchurl {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/freeimage/-/raw/main/freeimage-unbundle.patch";
      sha256 = "sha256-tC55n36XwscaAKfzUsI+z/VuuzYHe3/VqIZvRrXQEJQ=";
    })
    (pkgs.fetchurl {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/freeimage/-/raw/main/freeimage-libraw-0.21.patch";
      sha256 = "sha256-ystq46LOv4II006gFCOlMJ7oj/ZJr7uzceSc/rV9gzE=";
    })
    (pkgs.fetchurl {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/freeimage/-/raw/main/freeimage-libraw-0.20.patch";
      sha256 = "sha256-ccJZdMJd/O0RsIIGqubnWWdbU7rgYb5fNPoRB77skjM=";
    })
  ];

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = "http://freeimage.sourceforge.net/";
    license = "GPL";
    knownVulnerabilities = [];
  };
}
