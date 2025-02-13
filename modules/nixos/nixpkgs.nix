_: {
  nixpkgs = {
    config = {
      cudaSupport = true;
      allowUnfree = true;
      allowUnfreePredicate = true;
      permittedInsecurePackages = [
        "freeimage-unstable-2021-11-01"
        "SDL_ttf-2.0.11"
      ];
    };
  };
}
