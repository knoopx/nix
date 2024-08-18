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

  retroDeck = fetchTarball {
    url = "https://github.com/RetroDECK/RetroDECK/archive/refs/tags/0.8.3b.tar.gz";
    sha256 = "";
  };
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
    retroarch

    # bottles
    # xemu
    # protonup
    # wineWowPackages.waylandFull
    # melonDS
    # cemu
    # lutris
    # dosbox
    # https://redream.io/download/redream.x86_64-linux-v1.5.0-1131-gafdfc1a.tar.gz

    # (
    # datutil
    #   let
    #     pname = "datutil";
    #     version = "2.46";
    #     name = "${pname}-${version}";
    #   in
    #     stdenv.mkDerivation
    #     {
    #       inherit name;
    #       dontUnpack = true;
    #       sourceRoot = ".";
    #       src = fetchurl {
    #         url = "https://hitchhiker-linux.org/pub/stable/arch/x86_64/packages/DatUtil-2.46.tgz";
    #         sha256 = "sha256-raLkq1n0kQ9iPUqESLmGYd707W3zzq8+laaZszCVsro=";
    #       };

    #       installPhase = ''
    #         ${pkgs.gnutar}/bin/tar xf $src -C $out
    #       '';
    #     }
    # )

    (
      let
        pname = "es-de";
        version = "3.0.3";
        name = "${pname}-${version}";
      in (buildFHSEnv
        {
          inherit pname version;
          runScript = pname;

          targetPkgs = p: [
            libgpg-error
            e2fsprogs
            fribidi
            gmp
            (let
              src = appimageTools.extractType2 {
                inherit name;
                src = fetchurl {
                  url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/132901118/download";
                  sha256 = "sha256-cMLmTvnH4CGhIZsrTk/LsJBBxuNwFHyMchJQCG7EoOE=";
                };
              };
            in
              stdenv.mkDerivation
              {
                inherit name;
                src = "${src}/usr";
                installPhase = "cp -r $src $out";
              })
          ];
        })
    )
  ];
}
