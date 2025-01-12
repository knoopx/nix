{
  pkgs,
  config,
  ...
}: let
  retool = pkgs.retool.overrideAttrs (origAttrs: {
    postFixup =
      origAttrs.postFixup
      + ''
        ln -s ${config.home.homeDirectory}/.config/retool $out/bin/config
        ln -s ${config.home.homeDirectory}/.local/share/retool/datafile.dtd $out/bin/datafile.dtd
        ln -s ${config.home.homeDirectory}/.local/share/retool/clonelists $out/bin/clonelists
        ln -s ${config.home.homeDirectory}/.local/share/retool/metadata $out/bin/metadata
      '';
  });
in {
  imports = [
    ./metadata.nix
  ];

  home.packages = [
    retool
  ];
}
