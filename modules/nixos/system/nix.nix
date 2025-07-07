_: {
  nix = {
    gc.automatic = true;
    gc.dates = "5:00";

    optimise.automatic = true;
    optimise.dates = ["4:00"];

    settings = {
      sandbox = true;
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;

      substituters = [
        "https://cache.nixos.org"
        "https://cache.lix.systems"
        "https://nix-community.cachix.org"
        "https://niri.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://llama-cpp.cachix.org"
        # "https://nyx.chaotic.cx"
        # "https://hyprland.cachix.org"
        # "https://nixpkgs-wayland.cachix.org"
        # "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "ags.cachix.org-1:naAvMrz0CuYqeyGNyLgE010iUiuf/qx6kYrUv3NwAJ8="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "calops.cachix.org-1:6RTG80il2oS2ECFeG2QubG+mvD9OJc1s6Lm9JGAFcM0="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nightly-tools.cachix.org-1:UDM6zVPkMMG1F5s59vD4Je9WJA0SjGPI5P2V+dhZo8Y="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "llama-cpp.cachix.org-1:H75X+w83wUKTIPSO1KWy9ADUrzThyGs8P5tmAbkWhQc="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };

    # extraOptions = ''
    #   keep-outputs = true
    #   keep-derivations = true
    # '';
  };
}
