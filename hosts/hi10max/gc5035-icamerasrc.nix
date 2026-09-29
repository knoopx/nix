{ pkgs
, lib
, ...
}:

# GStreamer icamerasrc plugin (Vor-Art GC5035 recipe): intel/icamerasrc
# @ 4fb31db (2025-09-26) — the exact commit Intel's IPU6 PPA
# (ppa:oem-solutions-group/intel-ipu6) ships as
# gstreamer1.0-icamera 0~git202509260937.4fb31db~ubuntu24.04.9.
#
# Autotools build (configure.ac/Makefile.am). configure.ac requires
# PKG_CHECK_MODULES(CAMHAL, [libcamhal]) — satisfied by gc5035-camhal,
# which installs the libcamhal.pc + headers this commit's camHAL CMake
# would otherwise skip. CHROME_SLIM_CAMHAL=ON makes Makefile.am add
# -DCHROME_SLIM_CAMHAL (the chrome-slim build used by the Vor-Art
# stack).
pkgs.stdenv.mkDerivation {
  pname = "gc5035-icamerasrc";
  version = "unstable-2025-09-26";

  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "icamerasrc";
    rev = "4fb31db76b618aae72184c59314b839dedb42689";
    hash = "sha256-BYURJfNz4D8bXbSeuWyUYnoifozFOq6rSfG9GBKVoHo=";
  };

  nativeBuildInputs = [ pkgs.autoreconfHook pkgs.pkg-config ];

  preConfigure = ''
    export CHROME_SLIM_CAMHAL=ON
  '';

  configureFlags = [ "--enable-gstdrmformat=yes" ];

  buildInputs = [
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-bad
    (import ./gc5035-camhal.nix { inherit pkgs lib; })
    pkgs.libdrm
    pkgs.libva
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error"
    "-I${pkgs.gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "GStreamer icamerasrc plugin (Vor-Art GC5035 recipe) linked against gc5035-camhal";
    license = lib.licenses.lgpl21Plus;
    platforms = [ "x86_64-linux" ];
  };
}
