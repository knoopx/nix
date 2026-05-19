{pkgs}: let
  pname = "numnum";
  version = "0.2.2";

  src = pkgs.fetchFromGitHub {
    owner = "rudrabhoj";
    repo = "numnum";
    rev = "v${version}";
    hash = "sha256-1+eWjFxfgytIPs04Kt3pQtv0n1NliMbJDsT8uedeLIA=";
  };

  devLibraries = with pkgs; [
    egl-wayland
    freetype.dev
    fontconfig.dev
    libxcb.dev
    libxkbcommon.dev
    libX11.dev
    mesa
    vulkan-loader
    wayland
  ];

  runLibraries = with pkgs; [
    egl-wayland
    freetype
    fontconfig
    libgbm
    libxcb
    libxkbcommon
    libX11
    mesa
    vulkan-loader
    wayland
  ];
in
  pkgs.rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-+TQPb0YcRxwu8WqZOygybXaQY44GmRVqY6U/FP9C44Y=";
    doVendorCheck = false;

    nativeBuildInputs = with pkgs; devLibraries ++ [pkg-config cmake makeWrapper copyDesktopItems];

    buildInputs = devLibraries;

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "numnum";
        exec = "numnum %F";
        icon = "numnum";
        genericName = "Calculator";
        desktopName = "NumNum";
        categories = ["Utility" "Calculator"];
      })
    ];

    postInstall = ''
      wrapProgram $out/bin/numnum \
        --suffix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath runLibraries}"

      install -Dm444 ${src}/assets/icons/numnum.svg $out/share/icons/hicolor/scalable/apps/numnum.svg
    '';

    doCheck = false;

    meta = {
      description = "A text editor that does math — type expressions and get results as you type";
      homepage = "https://github.com/rudrabhoj/numnum";
      license = pkgs.lib.licenses.gpl2Only;
      maintainers = [];
      mainProgram = "numnum";
    };
  }
