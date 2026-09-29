{ pkgs
, lib
, ...
}:

# camHAL configuration tree for the CHUWI Hi10 Max front GC5035 camera.
#
# Starts from the ipu6ep camHAL base tree shipped by the nixpkgs
# ipu6ep-camera-hal package, adds the open GC5035 sensor profile from the
# CHUWI Hi10 Max Linux project, and prepends gc5035-uf-2 to the
# availableSensors list in libcamhal_profile.xml. The entry format is
# "<sensor>-<wf|uf>-<CSI port>": camHAL's dynamic detection
# (CameraParser::getAvailableSensors) parses the last dash-component as the
# CSI port and checks that a media entity "<sensor> <i2c>" feeds the
# "Intel IPU6 CSI2 <port>" entity (the kernel-7.2 driver DOES register the
# CSI2 ports as media entities). The GC5035 binds to CSI2 port 2 (media
# graph: gc5035 6-003f -> "Intel IPU6 CSI2 2"), so the entry is
# gc5035-uf-2; the -2 is stripped to gc5035-uf, which names the sensor
# profile file (sensors/gc5035-uf.xml) and the icamerasrc device-name.
#
# The two proprietary OEM assets (gc5035_CJAK519_ADL.aiqb and
# gcss/graph_settings_gc5035_CJAK519_ADL.xml) ship in-tree under oem/
# (pulled from the CHUWI driver bundle; SHA-256 verified against the
# EXPECTED digests in prepare-config.py) so the deployed tree is
# self-contained: it satisfies the prepare-config.py rules without
# depending on /var/lib/chuwi-hi10-max-linux/oem/ at runtime.
#
# The v4l2-relayd-ipu6 service points camHAL at the deployed tree with
# CAMERA_CFG_PATH (camHAL reads that environment variable first).

let
  # Haumea scoped loader: everything comes from pkgs.
  fetchurl = pkgs.fetchurl;

  sensorProfile = fetchurl {
    url = "https://raw.githubusercontent.com/Vor-Art/chuwi-hi10-max-linux/main/camera/userspace/gc5035-uf.xml";
    sha256 = "3b3e3cf0a0a8196ea47b63a5135048a128303b84e13acf188b930f8b82debe47";
  };
in
pkgs.stdenv.mkDerivation {
  pname = "gc5035-camera-hal";
  version = "1.0";

  # The tree is assembled in installPhase from the ipu6ep-camera-hal package
  # and the fetched sensor profile; there is no source to unpack.
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.python3 ];

  installPhase = ''
    runHook preInstall

    # Base camHAL tree for the IPU6EP platform.
    mkdir -p $out/camera
    cp -r ${pkgs.ipu6ep-camera-hal}/etc/camera/ipu6ep/* $out/camera/
    # Files copied from the read-only nix store keep read-only perms; make
    # the tree writable so the sensor profile and profile edit below land.
    chmod -R a+rwX $out/camera

    # GC5035 sensor profile.
    mkdir -p $out/camera/sensors
    cp ${sensorProfile} $out/camera/sensors/gc5035-uf.xml

    # OEM assets (in-tree, SHA-256-verified against prepare-config.py).
    # Nix path interpolation adds the files as build inputs; paths are
    # flake-root-relative (Nix resolves ./ against the flake root).
    cp ${./gc5035-camera-hal-oem/gc5035_CJAK519_ADL.aiqb} $out/camera/gc5035_CJAK519_ADL.aiqb
    cp ${./gc5035-camera-hal-oem/gcss/graph_settings_gc5035_CJAK519_ADL.xml} $out/camera/gcss/graph_settings_gc5035_CJAK519_ADL.xml

    # Prepend gc5035-uf-2 to the availableSensors list. The port suffix
    # selects the CSI2 media entity the sensor feeds (port 2); camHAL
    # strips it to gc5035-uf for the sensor profile file name.
    ${pkgs.python3}/bin/python3 - $out/camera/libcamhal_profile.xml <<'PYEOF'
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

    # Sanity: the profile must be valid XML and list the sensor first.
    ${pkgs.python3}/bin/python3 -c "
import xml.etree.ElementTree as ET
root = ET.parse('$out/camera/libcamhal_profile.xml').getroot()
available = root.find('./Common/availableSensors')
assert available is not None, 'availableSensors missing'
first = (available.get('value') or ',').split(',')[0].strip()
assert first == 'gc5035-uf-2', 'gc5035-uf-2 not first in availableSensors'
ET.parse('$out/camera/sensors/gc5035-uf.xml')
import os
assert os.path.isfile('$out/camera/gc5035_CJAK519_ADL.aiqb'), 'OEM AIQ tuning file missing at tree root'
assert os.path.isfile('$out/camera/gcss/graph_settings_gc5035_CJAK519_ADL.xml'), 'OEM graph settings missing in gcss/'
"

    runHook postInstall
  '';

  meta = {
    description = "camHAL configuration tree with the CHUWI Hi10 Max GC5035 sensor profile";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
