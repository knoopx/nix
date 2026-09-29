{ config
, lib
, pkgs
, ...
}@ inputs:
let
  vaDri = import ./va-dri.nix { inherit pkgs lib; };
in
# CHUWI Hi10 Max front camera (GC5035 over IPU6EP).
#
# The tablet's MIPI front camera is a GalaxyCore GC5035 behind the Intel
# IPU6EP ISP. The stock kernel has no sensor driver for it, so this module
# wires up the full stack:
#
#   hardware.ipu6        nixpkgs module: IPU6 ISYS out-of-tree modules,
#                        IPU6 firmware, udev/WirePlumber rules, and the
#                        v4l2-relayd + icamerasrc + v4l2loopback relay
#   gc5035-camera        out-of-tree kernel modules: GC5035 sensor driver,
#                        legacy IPU6 I2C bridge, patched int3472 discrete
#   gc5035-camera-hal    camHAL config tree with the GC5035 sensor profile
#   camera-config        boot service: deploys the HAL tree to /run/camera
#                        and copies in the user-owned OEM files
#
# The relay exposes the processed stream as /dev/video50 ("CHUWI Front
# Camera"); raw IPU6 nodes are disabled in WirePlumber.
#
# OEM files (required, user-owned):
#   /var/lib/chuwi-hi10-max-linux/oem/gc5035_CJAK519_ADL.aiqb
#   /var/lib/chuwi-hi10-max-linux/oem/gcss/graph_settings_gc5035_CJAK519_ADL.xml
# (from the CHUWI "Hi10 Max N150" Windows driver bundle; see
# github.com/Vor-Art/chuwi-hi10-max-linux)

{
  hardware.ipu6 = {
    enable = true;
    # Alder Lake-N (IPU6EP).
    platform = "ipu6ep";
  };

  boot = {
    extraModulePackages = [
      # Out-of-tree camera modules (host-local package file, imported with
      # the host's pkgs so it is not exposed as a flake package).
      ((import ./gc5035-camera.nix { inherit pkgs lib; }) (config.boot.kernelPackages))
    ];

    # Load the camera modules at boot. Order: the int3472 discrete driver
    # creates the sensor platform device (ACPI GCTI5035), the IPU6 bridge
    # provides the I2C adapter, then the GC5035 sensor binds.
    kernelModules = [
      "intel_skl_int3472_discrete"
      "ipu-bridge"
      "gc5035"
    ];
  };

  # Relay instance: CHUWI 720p YUY2 pipeline (the format PipeWire and
  # most V4L2 apps negotiate).
  services.v4l2-relayd.instances.ipu6 = {
    cardLabel = lib.mkForce "CHUWI Front Camera";
    input = {
      pipeline = lib.mkForce
        "icamerasrc device-name=gc5035-uf buffer-count=7 ! capsfilter caps=video/x-raw,format=NV12,width=1920,height=1080,framerate=30/1 ! videoconvert ! capsfilter caps=video/x-raw,format=YUY2,width=1920,height=1080,framerate=30/1";
      format = lib.mkForce "YUY2";
    };
  };

  # camHAL resolves its profile/policy files (ParserBase::getDataFromXmlFile)
  # as getCameraCfgPath() + <file> with NO separator inserted (plus a CWD
  # "./<file>" fallback). getCameraCfgPath() returns CAMERA_CFG_PATH verbatim,
  # else the compiled-in default (a store path that ends in '/'). The env
  # value must therefore KEEP its trailing slash, or the file name glues onto
  # the directory (e.g. /run/camera/ipu6eplibcamhal_profile.xml) and the
  # lookup fails with "libcamhal_profile.xml is not found".
  systemd.services.v4l2-relayd-ipu6 = {
    environment.CAMERA_CFG_PATH = "/run/camera/ipu6ep/";
    environment.LIBVA_DRIVERS_PATH = "${vaDri}/lib/dri";

    # Idempotent pre-start. The nixpkgs default relies on
    # `v4l2loopback-ctl add ... || [ $? -eq 17 ]` (EEXIST) to tolerate an
    # already-present device, which works but prints a scary
    # "failed to create device: File exists" on every restart. Check the
    # node first so the pre-start is explicitly idempotent and silent whether
    # the v4l2loopback device is new or already present (module loaded from a
    # prior boot/restart). The device number is hardware.ipu6.videoDeviceNumber
    # (default 50).
    preStart = lib.mkForce ''
      mkdir -p "$(dirname "$V4L2_DEVICE_FILE")"
      if [ ! -e /dev/video${toString config.hardware.ipu6.videoDeviceNumber} ]; then
        ${config.boot.kernelPackages.v4l2loopback.bin}/bin/v4l2loopback-ctl \
          add --name "Intel MIPI Camera" --exclusive-caps=1 ${toString config.hardware.ipu6.videoDeviceNumber} || [ $? -eq 17 ]
      fi
      echo /dev/video${toString config.hardware.ipu6.videoDeviceNumber} > "$V4L2_DEVICE_FILE"
    '';

    # Backpressure fix. The nixpkgs v4l2-relayd module generates the -o
    # pipeline as "appsrc … ! videoconvert ! v4l2sink device=$(cat
    # $V4L2_DEVICE_FILE)" with no option to inject elements. v4l2loopback is
    # created with max_buffers=2 and no consumer ever drains /dev/video50 on
    # this host (PipeWire is not holding it), so v4l2sink blocks after filling
    # the 2-buffer ring -> backpressure stalls icamerasrc/GC5035/ISP (relay
    # CPU 0, no fresh frames). Re-export the module's -o pipeline with a
    # dropping queue (max-size-buffers=8, leaky=downstream) before v4l2sink so
    # the source keeps producing while the loopback ring is full. Only the -o
    # stage changes; the input pipeline and the device file are untouched.
    # This gstreamer 1.28.6 build's `queue` element exposes max-size-buffers +
    # leaky, NOT the legacy max-buffers / drop-last names. The legacy names are
    # unknown properties: gst_parse_launch logs "no property max-buffers" and
    # drops the queue limits, which intermittently yields a NULL pipeline and
    # crashes v4l2-relayd (gst_element_set_state on NULL -> restart loop).
    script = lib.mkForce ''
      exec ${pkgs.v4l2-relayd}/bin/v4l2-relayd -i "${config.services.v4l2-relayd.instances.ipu6.input.pipeline}" -o "appsrc name=appsrc caps=video/x-raw,format=YUY2,width=1920,height=1080,framerate=30/1 ! videoconvert ! queue max-size-buffers=8 leaky=downstream ! v4l2sink name=v4l2sink device=$(cat $V4L2_DEVICE_FILE)"
    '';

    # Start the relay only after the camHAL config tree is deployed.
    after = [ "camera-config.service" ];
    wants = [ "camera-config.service" ];
  };

  # Deploy the camHAL config tree (store, immutable) to /run/camera and
  # copy in the user-owned OEM files before the relay starts.
  systemd.services.camera-config = {
    description = "Deploy IPU6 camHAL config tree with GC5035 OEM files";
    wantedBy = [ "multi-user.target" ];
    before = [ "v4l2-relayd-ipu6.service" ];
    after = [ "local-fs.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      rm -rf /run/camera/ipu6ep
      cp -r ${import ./gc5035-camera-hal.nix { inherit pkgs lib; }}/camera /run/camera/ipu6ep

      oem=/var/lib/chuwi-hi10-max-linux/oem
      if [ -f "$oem/gc5035_CJAK519_ADL.aiqb" ]; then
        cp "$oem/gc5035_CJAK519_ADL.aiqb" /run/camera/ipu6ep/
      else
        echo "camera-config: OEM AIQ tuning file missing: $oem/gc5035_CJAK519_ADL.aiqb" >&2
      fi
      if [ -f "$oem/gcss/graph_settings_gc5035_CJAK519_ADL.xml" ]; then
        cp "$oem/gcss/graph_settings_gc5035_CJAK519_ADL.xml" /run/camera/ipu6ep/gcss/
      else
        echo "camera-config: OEM graph settings missing: $oem/gcss/graph_settings_gc5035_CJAK519_ADL.xml" >&2
      fi
      chmod -R a+rX /run/camera/ipu6ep
    '';
  };
}
