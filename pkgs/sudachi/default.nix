{
  pkgs,
  fetchurl,
  fetchgit,
  ...
}: let
  nx_tzdb = pkgs.callPackage ./nx_tzdb.nix {};
  enet = fetchgit {
    url = "https://github.com/lsalzman/enet";
    sha256 = "sha256-YIqJC5wMTX4QiWebvGGm5EfZXLzufXBxUO7YdeQ+6Bk=";
  };
  dynarmic = fetchgit {
    url = "https://github.com/sudachi-emu/dynarmic";
    sha256 = "sha256-jpc5SVRGp9R1wxLVwFGtm/+SXngkY0+zQX2toh+9GaA=";
  };

  xbyak = fetchgit {
    url = "https://github.com/herumi/xbyak";
    sha256 = "sha256-xBLY6PgKMpX/ld37TbP8D8wNinGDJtZZzo5fSnYo7yw=";
  };
  libusb = fetchgit {
    url = "https://github.com/libusb/libusb";
    sha256 = "sha256-uR0hoA602HCXW4ky9G3t8jMD2TqWPh+yGfHQTBnoLaI=";
  };
  sirit = fetchgit {
    url = "https://github.com/sudachi-emu/sirit";
    sha256 = "sha256-eEXOfN5HgMn2YCHkz4qpkH0UBJtnTuyP3Z4Uv9J/6Ro=";
  };
  mbedtls = fetchgit {
    url = "https://github.com/sudachi-emu/mbedtls";
    sha256 = "sha256-IO+LSAzlXyvEGiODaXsM9hLkIa3LB1inK+qiJTCreEQ=";
  };
  opus = fetchgit {
    url = "https://github.com/xiph/opus";
    sha256 = "sha256-8Q7/pi9hp6ZbQYrYfkDk9D8ZFagESygPOOE07g8qBVQ=";
  };
  sdl = fetchgit {
    url = "https://github.com/libsdl-org/SDL";
    sha256 = "sha256-uRx9jU4H1fK9g5eObJY6mKJrAley5N8wKSs7FfenryI=";
  };
  cpp-httplib = fetchgit {
    url = "https://github.com/yhirose/cpp-httplib";
    sha256 = "sha256-TCnO+rFW6ZTau6egcnsPNW5vweb6H1GABDuOW69GixQ=";
  };
  sffmpeg = fetchgit {
    url = "https://github.com/FFmpeg/FFmpeg";
    sha256 = "sha256-Pl+Cqc8RTX9Je+31C2kirMC0DWZd/caGAc1RCiQ9eG8=";
  };
  cpp-jwt = fetchgit {
    url = "https://github.com/arun11299/cpp-jwt";
    sha256 = "sha256-cA8/oHAmeKf/1aZFw0WryD/Afxn2VNKCT13eOK30+sE=";
  };
  libadrenotools = fetchgit {
    url = "https://github.com/bylaws/libadrenotools";
    sha256 = "sha256-mxX2YpoxEnj0uPxLXmRR4wyEPBhQnlv5FXRazxypABs=";
  };
  breakpad = fetchgit {
    url = "https://github.com/sudachi-emu/breakpad";
    sha256 = "sha256-DuD4eu+JmVv9vN8SkUdG/VHY/uBt8/Zhif/5ggdr2vI=";
  };
  simpleini = fetchgit {
    url = "https://github.com/brofield/simpleini";
    sha256 = "sha256-DLxX0ZHUHSnS4TqqdGQWWuaGg7OmTtE5GxUzQeRqFSc=";
  };
  oaknut = fetchgit {
    url = "https://github.com/sudachi-emu/oaknut";
    sha256 = "sha256-9tM2OQrVxlIigpwx9JEM/mNzNWRsajvxPn3UvG5ULWM=";
  };
  VulkanMemoryAllocator = fetchgit {
    url = "https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator";
    sha256 = "sha256-t4ECABpiHL9IbE12JkJ0HmMIIaq6AnntawHMsIBSxno=";
  };

  tzdb_to_nx = fetchgit {
    url = "https://github.com/lat9nq/tzdb_to_nx";
    sha256 = "sha256-5p31PStFM+SpBT3TMNVpVR/XIsEnrP6E0Pxxxolvpek=";
  };
  cubeb = fetchgit {
    url = "https://github.com/mozilla/cubeb";
    sha256 = "sha256-PiyZrwhtPy4W5pGYCbgLHwMLis/cjlPcoWzxTHJwVro=";
  };
in
  pkgs.stdenv.mkDerivation {
    pname = "sudachi";
    version = "1.0.10";

    src =
      fetchurl
      {
        url = "https://github.com/emuplace/sudachi.emuplace.app/releases/download/v1.0.10/latest.zip";
        sha256 = "sha256-t1suU+JK4SYXfxwCq703dKmB+QrwgEvm7kM+yqtHN0g=";
      };

    sourceRoot = ".";

    nativeBuildInputs = with pkgs; [
      unzip
      cmake
      pkg-config
      glslang
      kdePackages.wrapQtAppsHook
      kdePackages.qttools
      libtool
      # breakpointHook
    ];

    buildInputs = with pkgs; [
      vulkan-headers
      vulkan-utility-libraries
      boost
      autoconf
      fmt
      nasm
      lz4
      nlohmann_json
      ffmpeg
      kdePackages.qtbase
      kdePackages.qtwayland
      kdePackages.qtmultimedia
      kdePackages.qtwebengine
      # SDL
      libva
      vcpkg
      udev
    ];

    # dontFixCmake = true;

    cmakeFlags = [
      "-DSUDACHI_CHECK_SUBMODULES=OFF"
      "-DSUDACHI_ENABLE_LTO=ON"
      "-DENABLE_QT6=ON"
      "-DENABLE_LIBUSB=OFF"
      "-DUSE_SDL2_FROM_EXTERNALS=OFF"
      "-DENABLE_SDL2=OFF"
      "-DSUDACHI_USE_BUNDLED_SDL2=OFF"
      "-DSUDACHI_USE_BUNDLED_VCPKG=OFF"
      "-DSUDACHI_USE_EXTERNAL_VULKAN_HEADERS=OFF"
      "-DSUDACHI_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=OFF"
      "-DSUDACHI_USE_BUNDLED_FFMPEG=ON"
      "-DENABLE_QT_TRANSLATION=OFF"
      "-DSUDACHI_USE_QT_WEB_ENGINE=ON"
      "-DSUDACHI_USE_QT_MULTIMEDIA=ON"
      "-DUSE_DISCORD_PRESENCE=OFF"
      "-DSUDACHI_ENABLE_COMPATIBILITY_REPORTING=OFF"
      # "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
    ];

    qtWrapperArgs = [
      "--prefix LD_LIBRARY_PATH : ${pkgs.vulkan-loader}/lib"
    ];

    env.NIX_CFLAGS_COMPILE = "-march=native";

    preConfigure = ''
      mkdir -p build/externals/nx_tzdb
      ln -s ${nx_tzdb} build/externals/nx_tzdb/nx_tzdb

      rm -Rf externals/SDL
      ln -s ${sdl} externals/SDL

      rm -Rf externals/dynarmic
      ln -s ${dynarmic} externals/dynarmic

      rm -Rf externals/xbyak
      ln -s ${xbyak} externals/xbyak

      rm -Rf externals/mbedtls
      ln -s ${mbedtls} externals/mbedtls

      rm -Rf externals/cubeb
      ln -s ${cubeb} externals/cubeb

      rm -Rf externals/enet
      ln -s ${enet} externals/enet

      rm -Rf externals/sirit
      ln -s ${sirit} externals/sirit

      rm -Rf externals/cpp-jwt
      ln -s ${cpp-jwt} externals/cpp-jwt

      rm -Rf externals/cpp-httplib
      ln -s ${cpp-httplib} externals/cpp-httplib

      rm -Rf externals/opus
      ln -s ${opus} externals/opus

      rm -Rf externals/libusb/libusb
      ln -s ${libusb} externals/libusb/libusb

      rm -Rf externals/libadrenotools
      ln -s ${libadrenotools} externals/libadrenotools

      rm -Rf externals/ffmpeg/ffmpeg
      ln -s ${sffmpeg} externals/ffmpeg/ffmpeg

      rm -Rf externals/VulkanMemoryAllocator
      ln -s ${VulkanMemoryAllocator} externals/VulkanMemoryAllocator

      rm -Rf externals/breakpad
      ln -s ${breakpad} externals/breakpad

      rm -Rf externals/simpleini
      ln -s ${simpleini} externals/simpleini

      rm -Rf externals/oaknut
      ln -s ${oaknut} externals/oaknut

      rm -Rf externals/nx_tzdb/tzdb_to_nx
      ln -s ${tzdb_to_nx} externals/nx_tzdb/tzdb_to_nx
    '';

    # postInstall = ''
    #   mkdir -p $out/lib/udev/rules.d
    #   install -m 444 -D dist/72-sudachi-input.rules -t $out/lib/udev/rules.d

    #   mkdir -p $out/share/applications
    #   install -m 755 -D dist/sudachi.desktop -t $out/share/applications
    #   substituteInPlace $out/share/applications/sudachi.desktop --replace "sudachi %f" "$out/bin/sudachi %f"

    #   mkdir -p $out/share/icons/hicolor/scalable/apps/
    #   install -m 644 -D dist/sudachi.svg -t $out/share/icons/hicolor/scalable/apps
    # '';
  }
