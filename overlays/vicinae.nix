final: prev: {
  vicinae = prev.vicinae.overrideAttrs (oldAttrs: {
    version = "0.16.2-fix-label-color";
    src = prev.fetchFromGitHub {
      owner = "knoopx";
      repo = "vicinae";
      rev = "fix-label-color";
      hash = "sha256-wsOYkvnB3pPLTJz2Usc+aB5sXGssnz5KPMdwJ4bRrdM=";
    };
  });
}
