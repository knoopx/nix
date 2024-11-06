{pkgs, ...}: (pkgs.factorio.overrideAttrs
  {
    pname = "factorio";
    version = "2.0.14";
    src = fetchTarball {
      url = "file:///mnt/storage/Games/factorio_linux_2.0.14.tar.xz";
      sha256 = "sha256:0jy2qxayis4gw6fsgr15nbm77fqxrrkvmm0lfw83lhnz9qc05lza";
    };
  })
