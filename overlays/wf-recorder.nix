final: prev: {
  wf-recorder = prev.wf-recorder.overrideAttrs (oldAttrs: rec {
    version = "0.6.0";
    src = prev.fetchFromGitHub {
      owner = "ammen99";
      repo = "wf-recorder";
      rev = "v${version}";
      hash = "sha256-CY0pci2LNeQiojyeES5323tN3cYfS3m4pECK85fpn5I=";
    };
    patches = [];
  });
}
