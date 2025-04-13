{
  pkgs,
  lib,
  ...
}: {
  environment = {
    sessionVariables = {
      # make gstreamer plugins available to apps
      GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
        gst-libav
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
        gst-plugins-ugly
        gst-vaapi
        gstreamer
      ]);
    };
  };
}
