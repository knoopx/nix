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
    (ryujinx.overrideAttrs (props: {
      version = "1.1.1396";
      src = fetchFromGitHub {
        owner = "Ryujinx";
        repo = "Ryujinx";
        rev = "2387b81deacad46f3e4f5f7e26ad4fe2dd7d754e";
        hash = "sha256-i0aXaQtAaGLWbMGZNYvkhnnA8aoHOYDxEYYDMy+GpIk=";
      };
      patches = [
        (pkgs.fetchurl {
          url = "https://github.com/knoopx/Ryujinx/commit/8759c6ebc.patch";
          sha256 = "sha256-qCm3BIek0+hTTgynYNayLPwIVv1y4bg/5XYYajnzJzA=";
        })
      ];
      makeWrapperArgs = [];
    }))

    rpcs3
    retroarchFull
    pcsx2
    xemu
    cemu
    higan
    (callPackage ../../pkgs/es-de-appimage.nix {})
    # (callPackage ../../pkgs/sudachi.nix {})
    # melonDS
    # dosbox
    # bottles
    # protonup
    # wineWowPackages.waylandFull
    # lutris
    # https://redream.io/download/redream.x86_64-linux-v1.5.0-1131-gafdfc1a.tar.gz
  ];
}
