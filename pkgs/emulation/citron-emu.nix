{pkgs, ...}: let
  tzdb_to_nx = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "tzdb_to_nx";
    version = "221202";
    src = pkgs.fetchurl {
      url = "https://github.com/lat9nq/tzdb_to_nx/releases/download/${version}/${version}.zip";
      hash = "sha256-mRzW+iIwrU1zsxHmf+0RArU8BShAoEMvCz+McXFFK3c=";
    };
    nativeBuildInputs = [
      pkgs.unzip
    ];
    buildCommand = "unzip $src -d $out";
  };
in
  pkgs.stdenv.mkDerivation rec {
    pname = "citron-emu";
    version = "dae1524eb59fac4b4ca0889d220d25e55eccfc84";

    src =
      fetchGit
      {
        url = "https://git.citron-emu.org/Citron/Citron.git";
        rev = version;
        submodules = true;
      };

    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
      kdePackages.wrapQtAppsHook
      libtool
      git
      glslang
    ];

    buildInputs = with pkgs; [
      git
      vulkan-headers
      vulkan-utility-libraries
      boost183
      autoconf
      automake
      fmt
      llvm_19
      nasm
      lz4
      nlohmann_json
      ffmpeg
      qt6.qtbase
      enet
      libva
      vcpkg
      libopus
      udev
      SDL2
    ];

    dontFixCmake = true;
    env.NIX_CFLAGS_COMPILE = "-march=native";

    cmakeFlags = [
      "-DCITRON_CHECK_SUBMODULES=OFF"
      "-DENABLE_QT6=ON"
      "-DCITRON_USE_BUNDLED_FFMPEG=OFF"
      "-DCITRON_USE_BUNDLED_VCPKG=OFF"
      "-DCITRON_USE_EXTERNAL_VULKAN_HEADERS=OFF"
      "-DCITRON_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=OFF"
      "-DCITRON_USE_EXTERNAL_SDL2=OFF"
      "-DCITRON_TESTS=OFF"
    ];

    #substituteInPlace CMakeLists.txt --replace-fail "VulkanHeaders 1.3.301" "VulkanHeaders 1.3"
    preConfigure = ''
      substituteInPlace externals/nx_tzdb/CMakeLists.txt --replace-fail "set(CAN_BUILD_NX_TZDB true)" "set(CAN_BUILD_NX_TZDB false)"
      mkdir -p build/externals/nx_tzdb
      ln -s ${tzdb_to_nx} build/externals/nx_tzdb/nx_tzdb
    '';

    meta.mainProgram = "citron";
  }
