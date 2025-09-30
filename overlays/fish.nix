final: prev: {
  fish = prev.fish.overrideAttrs {
    doCheck = false;
  };
}
