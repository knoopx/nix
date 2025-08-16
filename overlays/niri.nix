final: prev: {
  niri =
    prev.niri.overrideAttrs {doCheck = false;};
}
