{pkgs, ...}: let
  wrapWine = with builtins;
    {pkgs}: {
      package ? pkgs.wine,
      wineFlags ? "",
      executable,
      chdir ? null,
      name,
      tricks ? [],
      setupScript ? "",
      firstrunScript ? "",
    }: let
      tricksStmt =
        if (length tricks) > 0
        then concatStringsSep " " tricks
        else "-V";
      script = pkgs.writeShellScriptBin name ''
        PATH=$PATH:${package}/bin:${pkgs.winetricks}/bin
        HOME="$(echo ~)"
        WINE_NIX="$HOME/.wine-nix"
        export WINEPREFIX="$WINE_NIX/${name}"
        EXECUTABLE="${executable}"
        mkdir -p "$WINE_NIX"
        ${setupScript}
        if [ ! -d "$WINEPREFIX" ]
        then
          wine cmd /c dir > /dev/null 2> /dev/null # initialize prefix
          wineserver -w
          winetricks ${tricksStmt}
          ${firstrunScript}
        fi
        ${
          if chdir != null
          then ''cd "${chdir}"''
          else ""
        }
        if [ ! "$REPL" == "" ];
        then
          bash
          exit 0
        fi

        wine ${wineFlags} "$EXECUTABLE" "$@"
        wineserver -w
      '';
    in
      script;
in {
  # TODO:
  # home.files."/.config/retroarch/system" = {
  #  src = "/mnt/storage/emus/system";
  # }

  # home.files.".config/retroarch" = {
  #   src = "${retroDeck}/emu-configs/retroarch";
  #   recursive = true;
  # };

  home.packages = with pkgs; [
    mame-tools
    ryujinx
    retroarchFull
    xemu
    cemu
    (callPackage ../../pkgs/es-de.nix {})
    # melonDS
    # dosbox
    # bottles
    # protonup
    # wineWowPackages.waylandFull
    # lutris
    # https://redream.io/download/redream.x86_64-linux-v1.5.0-1131-gafdfc1a.tar.gz
  ];
}
