_: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = true;
      permittedInsecurePackages = [
        "freeimage-unstable-2021-11-01"
      ];
    };
  };
}
