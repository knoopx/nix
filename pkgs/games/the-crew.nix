{
  stdenvNoCC,
  pkgs,
  inputs,
  makeDesktopItem,
  ...
}: let
  pname = "the-crew";
  exePath = "${drv}/share/${pname}/TheCrew.exe";
  runner = "${inputs.nix-gaming.packages.${pkgs.system}.umu}/bin/umu-run";

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "The Crew";
      categories = ["Game"];
    })
  ];

  drv = stdenvNoCC.mkDerivation {
    name = pname;

    src = fetchTarball {
      url = "file:///mnt/storage/Games/windows/the-crew_worldwide_windows_uplay.7z";
      sha256 = "sha256:0896qqli29g73paa8v8vynx5a57bpb40fmz49kqmwa15miq7s2cz";
    };

    # sourceRoot = "./.";

    nativeBuildInputs = with pkgs; [
      unzip
    ];

    installPhase = ''
      find
      mkdir -p $out/{bin,share/${pname}}
      mv * $out/share/${pname}
    '';
  };
in
  pkgs.writeShellScriptBin pname ''
    export GAMEID=241560
    export PROTONPATH=GE-Proton
    ${runner} winetricks ubisoftconnect
    ${runner} ${exePath}
  ''
