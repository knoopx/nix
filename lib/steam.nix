{
  pkgs,
  symlinkJoin,
  ...
}: let
  steamAppDesktopItem = {
    pname,
    gameId,
    sha256,
  }:
    pkgs.stdenv.mkDerivation {
      name = "${pname}.desktop";

      nativeBuildInputs = with pkgs; [
        steamcmd
        icoutils
        wget
      ];

      dontUnpack = true;

      buildPhase = ''
        export HOME=$(pwd)

        meta=$(steamcmd +login anonymous +app_info_print ${toString gameId} +quit)
        name=$(grep -m1 '"name"' <<<"$meta" | sed 's/"name"//' | tr -d '"\t')
        digest=$(grep -m1 '"clienticon"' <<< "$meta" | awk "{print \$2}" | tr -d '"')
        url="https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps/${toString gameId}/$digest.ico"

        wget --no-check-certificate $url

        icotool -x -o . $digest.ico

        mkdir -p $out/share/{pixmaps,applications}

        mv ''${digest}_*256x256*.png $out/share/pixmaps/${pname}.png

        cat <<DESKTOP > $out/share/applications/${pname}.desktop
        [Desktop Entry]
        Name=''${name}
        Icon=${pname}
        Exec=${pname}
        Categories=Game
        DESKTOP
      '';

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = sha256;
    };

  umuWrapper = {
    pname,
    gameId,
    entrypoint,
    runner ? "${pkgs.umu}/bin/umu-run",
    proton ? "GE-Proton",
    setup ? "",
  }:
    pkgs.writeShellScriptBin pname ''
      export GAMEID=${toString gameId}
      export PROTONPATH=${proton}

      ${setup}
      ${runner} ${entrypoint}
    '';

  umuDwarfWrapper = {dwarf, ...} @ rest:
    umuWrapper (removeAttrs (rest
      // {
        setup = ''
          TMP_MOUNT_DIR=$(mktemp -d /tmp/mount-XXXX)

          cleanup() {
              umount -l "$TMP_MOUNT_DIR"
              rmdir "$TMP_MOUNT_DIR"
          }
          trap cleanup EXIT

          dwarfs "${dwarf}" $TMP_MOUNT_DIR
          pushd $TMP_MOUNT_DIR
        '';
      }) ["dwarf"]);

  steamApp = {
    pname,
    gameId,
    wrapper,
    sha256,
  }:
    symlinkJoin {
      pname = "${pname}-steamapp-${toString gameId}";
      version = toString gameId;
      paths = [
        wrapper
        (steamAppDesktopItem {inherit pname gameId sha256;})
      ];
    };
in {
  inherit steamApp umuWrapper umuDwarfWrapper;
}
