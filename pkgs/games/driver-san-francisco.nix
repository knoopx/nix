{
  stdenvNoCC,
  pkgs,
  ...
}: let
  name = "driver-san-francisco";
  exePath = "${drv}/share/${name}/source/Driver.exe";
  runner = "${pkgs.umu}/bin/umu-run";

  drv = stdenvNoCC.mkDerivation {
    inherit name;

    src = fetchTarball {
      url = "file:///mnt/storage/Games/driver-san-francisco_win32.tar.lrz";
      sha256 = "sha256:03a9l3z90c01786hpy81rkxyka4sc8v4al74wqhb1pjz69slld4b";
    };

    sourceRoot = "./.";

    nativeBuildInputs = with pkgs; [
      lrzip
    ];

    installPhase = ''
      mkdir -p $out/{bin,share/${name}}
      mv * $out/share/${name}
    '';
  };
in
  pkgs.writeShellScriptBin name ''
    export GAMEID=33440
    export PROTONPATH=GE-Proton
    ${runner} ${exePath}
  ''
