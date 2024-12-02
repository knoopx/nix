{pkgs, ...}: let
  # tzdb_to_nx = pkgs.stdenv.mkDerivation rec {
  #   pname = "tzdb_to_nx";
  #   version = "221202";
  #   src = pkgs.fetchurl {
  #     url = "https://github.com/lat9nq/tzdb_to_nx/releases/download/${version}/${version}.zip";
  #     hash = "sha256-mRzW+iIwrU1zsxHmf+0RArU8BShAoEMvCz+McXFFK3c=";
  #   };
  #   nativeBuildInputs = [
  #     pkgs.unzip
  #   ];
  #   buildCommand = "unzip $src -d $out";
  # };
in
  pkgs.stdenv.mkDerivation rec {
    pname = "citron-emu";
    version = "b0fd87f7be7e29b53bb75dc8a7a7539c007c8ec3";

    src =
      fetchGit
      {
        url = "https://git.citron-emu.org/Citron/Citron.git";
        rev = version;
        submodules = true;
      };

    sourceRoot = "source";

    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
      kdePackages.wrapQtAppsHook
      libtool
      git
      # unzip
      glslang
      # kdePackages.qttools
      # vulkan-headers
      # vulkan-utility-libraries
    ];

    buildInputs = with pkgs; [
      git
      vulkan-headers
      vulkan-utility-libraries
      boost185
      autoconf
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
    ];

    # dontFixCmake = true;
    # env.NIX_CFLAGS_COMPILE = "-march=native";

    cmakeFlags = [
      "-DCITRON_CHECK_SUBMODULES=OFF"
      # "-DCITRON_DOWNLOAD_TIME_ZONE_DATA=OFF"
      "-DENABLE_QT6=ON"
      "-DENABLE_SDL2=OFF"
      # "-DENABLE_LIBUSB=OFF"
      "-DCITRON_USE_BUNDLED_FFMPEG=OFF"
      "-DCITRON_USE_BUNDLED_VCPKG=OFF"
      "-DCITRON_USE_EXTERNAL_VULKAN_HEADERS=OFF"
      "-DCITRON_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=OFF"
      # "-DCITRON_ENABLE_LTO=ON"
      # "-DUSE_SDL2_FROM_EXTERNALS=OFF"
      # "-DENABLE_QT_TRANSLATION=OFF"
      # "-DCITRON_USE_QT_WEB_ENGINE=ON"
      # "-DCITRON_USE_QT_MULTIMEDIA=ON"
      # "-DUSE_DISCORD_PRESENCE=OFF"
      # "-DCITRON_ENABLE_COMPATIBILITY_REPORTING=OFF"
      # "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
    ];

    # nix bundle --bundler github:ralismark/nix-appimage nixpkgs#hello
    # substituteInPlace externals/nx_tzdb/CMakeLists.txt  --replace-fail "set(NX_TZDB_ROMFS_DIR \"\''${CMAKE_CURRENT_BINARY_DIR}/nx_tzdb\")" "set(NX_TZDB_ROMFS_DIR \"${tzdb_to_nx}\")"
    # rm -rf externals/nx_tzdb/tzdb_to_nx/externals/tz
    preConfigure = ''
      substituteInPlace CMakeLists.txt --replace-fail "VulkanHeaders 1.3.301" "VulkanHeaders 1.3"
    '';
  }
