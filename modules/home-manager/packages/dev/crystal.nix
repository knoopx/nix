# TODO: Re-enable when crystal package is fixed in nixpkgs
# (env.FLAGS as list is no longer allowed in Nix 2.31+)
{pkgs, ...}: {
  home.packages = with pkgs; [
    # crystal
    # crystalline
    # shards
  ];
}
