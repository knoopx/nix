{pkgs, ...}: {
  home.packages = with pkgs; [
    crystal
    crystalline
    shards
    (mint.overrideAttrs
      rec {
        version = "0.27.0";
        doCheck = false;
        src = fetchFromGitHub {
          owner = "mint-lang";
          repo = "mint";
          tag = version;
          hash = "sha256-nmQzJ+LkNJ3WSW1F59vRQpNiYgml4xkTj745vWPPUEE=";
        };
      })
  ];
}
