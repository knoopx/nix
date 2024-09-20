{pkgs, ...}: let
  lib = pkgs.lib;
  nx_tzdb = pkgs.callPackage ./nx_tzdb.nix {};
in
  pkgs.stdenv.mkDerivation rec {
    pname = "sudachi";
    version = "128b258427ec9a836343a0738fb09e335377174d";

    src =
      pkgs.fetchgit
      {
        url = "https://git.nya.network/yuzu-emu/sudachi.git";
        rev = version;
        fetchSubmodules = true;
        hash = "sha256-lY5NrCgirgWmzT1mHu7niirUDGb7kyAti+YdjwaIUeE=";
      };

    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
      glslang
      kdePackages.wrapQtAppsHook
      kdePackages.qttools
      # breakpointHook
    ];

    buildInputs = with pkgs; [
      # vulkan-headers must come first, so the older propagated versions
      # don't get picked up by accident
      vulkan-headers
      boost
      catch2_3
      cpp-jwt
      cubeb
      discord-rpc
      # intentionally omitted: dynarmic - prefer vendored version for compatibility
      enet
      # vendored ffmpeg deps
      autoconf
      ffmpeg
      fmt
      # intentionally omitted: gamemode - loaded dynamically at runtime
      # intentionally omitted: httplib - upstream requires an older version than what we have
      libopus
      libusb1
      # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
      lz4
      nlohmann_json
      kdePackages.qtbase
      kdePackages.qtmultimedia
      kdePackages.qtwayland
      kdePackages.qtwebengine
      # intentionally omitted: renderdoc - heavy, developer only
      SDL2
      # not packaged in nixpkgs: simpleini
      # intentionally omitted: stb - header only libraries, vendor uses git snapshot
      # not packaged in nixpkgs: vulkan-memory-allocator
      # intentionally omitted: xbyak - prefer vendored version for compatibility
      zlib
      zstd
    ];

    dontFixCmake = true;

    cmakeFlags = [
      # actually has a noticeable performance impact
      "-DSUDACHI_ENABLE_LTO=ON"

      # build with qt6
      "-DENABLE_QT6=ON"
      "-DENABLE_LIBUSB=OFF"
      "-DENABLE_QT_TRANSLATION=ON"

      # use system libraries
      "-DSUDACHI_USE_EXTERNAL_SDL2=OFF"
      "-DSUDACHI_USE_EXTERNAL_VULKAN_HEADERS=OFF"

      "-DSUDACHI_USE_BUNDLED_FFMPEG=OFF"

      # don't check for missing submodules
      "-DSUDACHI_CHECK_SUBMODULES=OFF"

      # enable some optional features
      "-DSUDACHI_USE_QT_WEB_ENGINE=ON"
      "-DSUDACHI_USE_QT_MULTIMEDIA=ON"
      "-DUSE_DISCORD_PRESENCE=OFF"

      # We dont want to bother upstream with potentially outdated compat reports
      "-DSUDACHI_ENABLE_COMPATIBILITY_REPORTING=OFF"
      "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
    ];

    qtWrapperArgs = [
      "--prefix LD_LIBRARY_PATH : ${pkgs.vulkan-loader}/lib"
    ];
    env.NIX_CFLAGS_COMPILE = lib.optionalString pkgs.stdenv.hostPlatform.isx86_64 "-msse4.1";
    # In the original, we changed the title bar. I decided to keep
    # it at its default
    preConfigure = ''
      mkdir -p build/externals/nx_tzdb
      ln -s ${nx_tzdb} build/externals/nx_tzdb/nx_tzdb
    '';

    postInstall = ''
      install -Dm444 $src/dist/72-sudachi-input.rules $out/lib/udev/rules.d/72-sudachi-input.rules
    '';
  }
