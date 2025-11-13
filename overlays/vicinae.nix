final: prev: {
  vicinae = prev.vicinae.overrideAttrs (oldAttrs: rec {
    version = "v0.16.5";
    src = prev.fetchFromGitHub {
      owner = "vicinaehq";
      repo = "vicinae";
      rev = version;
      hash = "sha256-smhbchRZmp7DwRLGA3QoI12kQuMVaxiNkhzfC+n19+4=";
    };
  });
}
