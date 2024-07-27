{...}: {
  nix = {
    gc.automatic = true;
    gc.dates = "5:00";

    optimise.automatic = true;
    optimise.dates = ["5:15"];

    settings = {
      experimental-features = ["nix-command" "flakes"];
      sandbox = true;
      # max-jobs = 16;
      # cores = 16;
      auto-optimise-store = true;
    };
  };
}
