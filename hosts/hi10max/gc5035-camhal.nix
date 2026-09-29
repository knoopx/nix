{ pkgs
, lib
, ...
}:

let
  v = "unstable-2026-01-20";
  gc5035SensorProfile = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Vor-Art/chuwi-hi10-max-linux/main/camera/userspace/gc5035-uf.xml";
    sha256 = "3b3e3cf0a0a8196ea47b63a5135048a128303b84e13acf188b930f8b82debe47";
  };
in
# Vor-Art GC5035 camHAL: intel/ipu6-camera-hal @ 9899efa (2026-01-20) —
# the exact commit Intel's IPU6 PPA (ppa:oem-solutions-group/intel-ipu6)
# ships as libcamhal-ipu6ep 0~git202601200757.9899efa~ubuntu24.04.3.
# Newer than the nixpkgs 20250923_ov02e baseline: getCameraCfgPath() in
# src/platformdata/PlatformData.cpp honors the CAMERA_CFG_PATH env var
# (fallback to the compiled-in CAMERA_DEFAULT_CFG_PATH), which is what the
# v4l2-relayd service uses to point camHAL at the bundled GC5035 tree.
#
# This commit's CMake only installs headers and libcamhal.pc when
# NOT BUILD_CAMHAL_PLUGIN; with the Vor-Art adaptor+plugin build neither
# is installed, so postInstall installs both itself (icamerasrc's
# PKG_CHECK_MODULES(CAMHAL, [libcamhal]) needs the .pc). The adaptor
# dlopens the plugin from CAMHAL_PLUGIN_DIR, baked at build time as
# ${CMAKE_INSTALL_FULL_LIBDIR}/libcamhal/plugins/ — with
# CMAKE_INSTALL_PREFIX=$out that is $out/lib/libcamhal/plugins/ipu6ep.so,
# so the store layout is self-contained and only the ipu6-camera-bins
# rpath is needed.
#
# The GC5035 config files (the fetched sensor profile plus the bundled
# OEM .aiqb/gcss files) are augmented onto the base ipu6ep tree the
# CMake installs from config/linux/ipu6ep/ at $out/etc/camera/ipu6ep —
# self-contained, with no dependency on ./gc5035-camera-hal.nix (the
# host overlay's ipu6ep-camera-hal -> gc5035-camhal redirect would
# turn such a dependency into a closure cycle).
pkgs.stdenv.mkDerivation {
  pname = "gc5035-camhal";
  version = v;

  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-camera-hal";
    rev = "9899efa70921906ee6dd23c9f83aff343968f164";
    hash = "sha256-p6xLgqVLLcfI5Ub5bux9UKo7tugFYl+g12Zh4N73WiI=";
  };

  nativeBuildInputs = [ pkgs.cmake pkgs.pkg-config pkgs.python3 ];
  enableParallelBuilding = true;

  # The stock config-id detection (enumEntities) keys off the FIRST
  # enumerated media entity: "Intel IPU6 CSI-2" -> downstream,
  # "Intel IPU6 CSI2" -> upstream. On the upstream kernel IPU6 driver the
  # first entity is an ISYS capture node, so the id stays unset and the
  # model check below rejects the device (-EINVAL): no sensors are
  # detected and icamerasrc registers no device-name property. The
  # patch falls back to the device model when the first entity is
  # inconclusive.
  patchPhase = ''patch -p1 < ${./gc5035-camhal-media-cfg.patch}'';

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DBUILD_CAMHAL_ADAPTOR=ON"
    "-DBUILD_CAMHAL_PLUGIN=ON"
    "-DIPU_VERSIONS=ipu6ep"
    "-DUSE_PG_LITE_PIPE=ON"
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error" ];

  buildInputs = [
    pkgs.expat
    pkgs.ipu6-camera-bins
    pkgs.libtool
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.libdrm
  ];

  postInstall = ''
    # 1. Headers — the CMake skips the include/ install with
    #    BUILD_CAMHAL_PLUGIN=ON; icamerasrc needs them via the .pc.
    #    (src/include contains api/, linux/, utils/ at this rev.)
    mkdir -p $out/include/libcamhal
    cp -r $src/include/* $out/include/libcamhal/

    # 2. pkg-config file — also skipped by the CMake with PLUGIN=ON.
    #    Rendered from src/cmake/libcamhal.pc.cmakein the same way
    #    configure_file would (@ONLY substitutions).
    mkdir -p $out/lib/pkgconfig
    sed -e 's|@CMAKE_INSTALL_PREFIX@|${placeholder "out"}|g' \
        -e 's|@CMAKE_INSTALL_LIBDIR@|lib|g' \
        -e 's|@VERSION@|'${v}'|g' \
        $src/cmake/libcamhal.pc.cmakein > $out/lib/pkgconfig/libcamhal.pc

    # 3. GC5035 config tree: augment the base ipu6ep tree the CMake
    #    installed from config/linux/ipu6ep/ (same merge as
    #    ./gc5035-camera-hal.nix, inlined here so this package has no
    #    dependency on gc5035-camera-hal — which the host overlay's
    #    ipu6ep-camera-hal redirect would turn into a closure cycle).
    chmod -R a+rwX $out/etc/camera/ipu6ep
    mkdir -p $out/etc/camera/ipu6ep/sensors $out/etc/camera/ipu6ep/gcss
    cp ${gc5035SensorProfile} $out/etc/camera/ipu6ep/sensors/gc5035-uf.xml
    cp ${./gc5035-camera-hal-oem/gc5035_CJAK519_ADL.aiqb} $out/etc/camera/ipu6ep/
    cp ${./gc5035-camera-hal-oem/gcss/graph_settings_gc5035_CJAK519_ADL.xml} $out/etc/camera/ipu6ep/gcss/
    # Prepend gc5035-uf-2 to the availableSensors list. The port suffix
    # selects the CSI2 media entity the sensor feeds (port 2); camHAL
    # strips it to gc5035-uf for the sensor profile file name (sensors/
    # gc5035-uf.xml). A suffix-less entry (gc5035-uf) parses "uf" as the
    # CSI port, matches no "Intel IPU6 CSI2 uf" entity, and is dropped by
    # the dynamic detection — so no camera is created and icamerasrc
    # registers no device-name property.
    ${pkgs.python3}/bin/python3 - $out/etc/camera/ipu6ep/libcamhal_profile.xml <<'PYEOF'
import re
import sys

path = sys.argv[1]
text = open(path).read()
m = re.search(r'(<availableSensors\s+value=")([^"]*)(")', text)
if m is None:
    sys.exit("availableSensors attribute not found in libcamhal_profile.xml")
sensors = [s.strip() for s in m.group(2).split(",") if s.strip()]
sensors = [s for s in sensors if s not in ("gc5035-uf", "gc5035-uf-2")]
sensors.insert(0, "gc5035-uf-2")
open(path, "w").write(
    text[:m.start()] + m.group(1) + ",".join(sensors) + m.group(3) + text[m.end():]
)
PYEOF
  '';

  postFixup = ''
    # The adaptor dlopens <CAMHAL_PLUGIN_DIR>ipu6ep.so, where
    # CAMHAL_PLUGIN_DIR is baked at build time as
    # $out/lib/libcamhal/plugins/ — cover both the top-level
    # libcamhal.so and the plugin with the ipu6-camera-bins rpath.
    for lib in $(find $out/lib -name '*.so' -o -name '*.a' | grep -v '\.a$'); do
      patchelf --add-rpath "${pkgs.ipu6-camera-bins}/lib" "$lib"
    done
  '';

  meta = {
    description = "Intel IPU6 camHAL (Vor-Art GC5035 recipe) with the GC5035 config tree bundled";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
