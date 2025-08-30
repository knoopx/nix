{pkgs, ...}: let
  src = pkgs.fetchFromGitHub {
    owner = "knoopx";
    repo = "vicinae";
    rev = "main";
    hash = "sha256-J4Hi0a2QU0T0j9ahkAJ/fdCN/FqeDWkeV4DlrT7gKZQ=";
  };

  # Prepare node_modules for api folder
  apiDeps = pkgs.fetchNpmDeps {
    src = src + /api;
    hash = "sha256-7rsaGjs1wMe0zx+/BD1Mx7DQj3IAEZQvdS768jVLl3E=";
  };

  # Prepare node_modules for extension-manager folder
  extensionManagerDeps = pkgs.fetchNpmDeps {
    src = src + /extension-manager;
    hash = "sha256-7kScWi1ySUBTDsGQqgpt2wYmujP9Mlwq3x2FKOlGwgo=";
  };

  ts-protoc-gen-wrapper = pkgs.writeShellScriptBin "protoc-gen-ts_proto" ''
    exec node /build/source/vicinae-upstream/api/node_modules/.bin/protoc-gen-ts_proto
  '';
in
  pkgs.stdenv.mkDerivation rec {
    pname = "vicinae";
    version = src.rev;

    inherit src;

    cmakeFlags = [
      "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
      "-DCMAKE_INSTALL_DATAROOTDIR=share"
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
    ];

    nativeBuildInputs = with pkgs; [
      ts-protoc-gen-wrapper
      extensionManagerDeps
      autoPatchelfHook
      cmake
      ninja
      nodejs
      pkg-config
      qt6.wrapQtAppsHook
      rapidfuzz-cpp
      protoc-gen-js
      protobuf
      grpc-tools
      which
      rsync
      breakpointHook
      typescript
    ];

    buildInputs = with pkgs; [
      qt6.qtbase
      qt6.qtsvg
      qt6.qttools
      qt6.qtwayland
      qt6.qtdeclarative
      qt6.qt5compat
      wayland
      kdePackages.qtkeychain
      kdePackages.layer-shell-qt
      minizip
      grpc-tools
      protobuf
      nodejs
      minizip-ng
      cmark-gfm
      libqalculate
    ];

    configurePhase = ''
      cmake -G Ninja -B build $cmakeFlags
    '';

    buildPhase = ''
      export npm_config_cache=${apiDeps}
      cd /build/source/api
      npm i --ignore-scripts
      patchShebangs /build/source/api
      npm rebuild --foreground-scripts
      export npm_config_cache=${extensionManagerDeps}
      cd /build/source/extension-manager
      npm i --ignore-scripts
      patchShebangs /build/source/extension-manager
      npm rebuild --foreground-scripts
      cd /build/source
      substituteInPlace cmake/ExtensionApi.cmake cmake/ExtensionManager.cmake --replace-fail "COMMAND npm install" ""
      cmake --build build
      cd /build/source
    '';

    postFixup = ''
      wrapProgram $out/bin/vicinae \
      --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath buildInputs} \
      --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [
        nodejs
        qt6.qtwayland
        wayland
      ])}
    '';

    installPhase = ''
      cmake --install build
    '';
  }
