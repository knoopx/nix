{ pkgs }:
let
  # ninfer requires CUDA >= 13.1 and only supports CMAKE_CUDA_ARCHITECTURES=120a
  # (hard-checked in its CMakeLists). cudaPackages_13 is CUDA 13.2.
  cuda = pkgs.cudaPackages_13;
in
pkgs.clangStdenv.mkDerivation rec {
  pname = "ninfer";
  version = "0.1.0-git9005987";

  src = pkgs.fetchFromGitHub {
    owner = "Neroued";
    repo = "ninfer";
    rev = "9005987486b6e53bffaee4fbaabbdaadc695a8a1";
    hash = "sha256-FPzxfnR22i97NgjutdGVPydHeLMIfB7J30ButjuP9do=";
  };

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.ninja
    pkgs.pkg-config
    # CMake 4 auto-uses clang-scan-deps for dependency scanning; the wrapped
    # clang-tools ensures it gets the nixpkgs C++ stdlib headers
    # (see NixOS/nixpkgs#273875).
    pkgs.clang-tools
    # provides nvcc + setup-cuda-hook (constructs CUDAToolkit_ROOT)
    cuda.cuda_nvcc
  ];

  buildInputs = [
    # FFMPEG via pkg-config: libavformat>=60 libavcodec>=60 libavutil>=58 libswscale>=7
    pkgs.ffmpeg
    # libcurl>=7.85 via pkg-config (dev output carries libcurl.pc + .so)
    pkgs.curl.dev
    # CUDA runtime (also carries lib/stubs for the cuda_driver link)
    cuda.cuda_cudart
    # nvtx3 (CUDA::nvtx3)
    cuda.cuda_nvtx
  ];

  # Hard constraint from upstream CMakeLists (FATAL_ERROR otherwise).
  # NINFER_BUILD_APPS=ON and Release build type are the upstream defaults.
  cmakeFlags = [ "-DCMAKE_CUDA_ARCHITECTURES=120a" ];

  # nvcc uses its default host compiler (gcc); C++ TUs are compiled by
  # clangStdenv's clang. Both share the libstdc++ ABI, so this is safe.
  enableParallelBuilding = true;
  doCheck = false; # no meaningful host-side tests; GPU-only runtime

  # No cmake install() calls upstream — install the apps ourselves.
  installPhase = ''
    runHook preInstall
    # cwd is still $cmakeBuildDir (build/) from the cmake hook
    install -Dm0755 apps/ninfer "$out/bin/ninfer"
    install -Dm0755 apps/ninfer-serve "$out/bin/ninfer-serve"
    runHook postInstall
  '';

  passthru = {
    inherit cuda;
  };

  meta = with pkgs.lib.meta; {
    description = "C++/CUDA inference engine and server for .ninfer model artifacts";
    longDescription = ''
      Self-contained C++20/CUDA inference stack (NVFP4 kernels included),
      compiled exclusively for sm_120a. Builds the `ninfer` CLI and the
      `ninfer-serve` HTTP server.
    '';
    homepage = "https://github.com/Neroued/ninfer";
    license = licenses.unfreeRedistributable;
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "ninfer";
  };
}
