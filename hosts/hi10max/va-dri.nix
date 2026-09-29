{ pkgs
, lib
, ...
}:

# i915 VA-API driver bundle for the v4l2-relayd GStreamer pipeline.
#
# The relay's icamerasrc plugin opens a VA-API DRM display via libva,
# which dlopens "<LIBVA_DRIVERS_PATH>/i915_drv_video.so" (the i915 DRM
# driver name). nixpkgs' intel-vaapi-driver ships the driver as
# "i965_drv_video.so", so libva never finds it -> "Couldn't create a
# VA DRM display" (which cascades into the g_param_spec_enum /
# GST_IS_ELEMENT assertions and a NULL pipeline element). This bundle
# re-exposes the driver under the i915 name libva looks for.
pkgs.runCommand "i915-va-dri" { } ''
  mkdir -p $out/lib/dri
  cp ${pkgs.intel-vaapi-driver}/lib/dri/i965_drv_video.so $out/lib/dri/
  ln -s i965_drv_video.so $out/lib/dri/i915_drv_video.so
''
