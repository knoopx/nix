{pkgs, ...}: (
  pkgs.factorio-space-age.overrideAttrs
  {
    version = "2.0.14";
    src = fetchTarball {
      url = "file:///mnt/storage/Games/factorio-space-age_linux_2.0.14.tar.xz";
      sha256 = "sha256:047h66lp6bg92njsss0l5a9pipd9v578cxqrdf6aql54z2wsp9hq";
    };
  }
)
