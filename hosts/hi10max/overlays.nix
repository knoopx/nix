# hi10max host-scoped overlays (imported by the flake's mkNixosModules as a
# single overlay; applied to the nixpkgs used by this host's modules).
#
# Vor-Art GC5035 camera recipe (github.com/Vor-Art/chuwi-hi10-max-linux,
# Intel OEM Solutions IPU6 PPA pair: libcamhal-ipu6ep
# 0~git202601200757.9899efa + gstreamer1.0-icamera
# 0~git202509260937.4fb31db). The stock nixpkgs ipu6ep-camera-hal (tag
# 20250923_ov02e) bakes its config dir in at build time and ignores the
# CAMERA_CFG_PATH env var, so it cannot enumerate the GC5035 (0 cameras ->
# icamerasrc device-name=gc5035-uf builds NULL). The Vor-Art camHAL build
# honors CAMERA_CFG_PATH at runtime; both refs are built in
# ./gc5035-camhal.nix and ./gc5035-icamerasrc.nix (host-local, imported —
# pkgs/ only carries global packages), with the GC5035
# config tree bundled into camHAL's own etc/camera/ipu6ep/ (augmented onto
# camHAL's own base tree) as the compiled-in fallback.
#
# Wiring:
#   ipu6ep-camera-hal -> gc5035-camhal (the libcamhal the relay's
#                        icamerasrc plugin links)
#   gst_all_1.icamerasrc-ipu6ep -> gc5035-icamerasrc (picked up by the
#                        hardware.ipu6 module's v4l2-relayd instance
#                        extraPackages, so v4l2-relayd@ipu6 runs the
#                        Vor-Art builds)
#
# The relay keeps CAMERA_CFG_PATH=/run/camera/ipu6ep (camera.nix;
# camera-config.service deploys the tree) — the new camHAL honors it.
# The gc5035 kernel modules stay in ./gc5035-camera.nix (camera.nix).
# The camera package files are host-local (imported, not haumea packages):
# pkgs/ only carries global packages.
final: prev:
  let
    gc5035Camhal = import ./gc5035-camhal.nix { pkgs = final; lib = final.lib; };
    gc5035Icamerasrc = import ./gc5035-icamerasrc.nix { pkgs = final; lib = final.lib; };
  in
  {
    ipu6ep-camera-hal = gc5035Camhal;

    gst_all_1 = prev.gst_all_1 // {
      icamerasrc-ipu6ep = gc5035Icamerasrc;
    };
  }
