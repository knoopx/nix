_: {
  nixpkgs = {
    config = {
      cudaSupport = true;
      allowUnfree = true;
      allowUnfreePredicate = true;
      permittedInsecurePackages = [
      ];
    };
  };
}
