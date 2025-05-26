{
  pkgs,
  defaults,
  lib,
  ...
}: {
  environment = {
    variables = {
    };

    sessionVariables = {
      EDITOR = defaults.editor;
      AI_PROVIDER = "pollinations";
      OLLAMA_API_BASE = "http://127.0.0.1:11434";
      OPENAI_API_BASE = "https://text.pollinations.ai/openai";
      OPENAI_API_KEY = "pollinations";
      NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-bundle.crt";

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

      PYTHONPATH = "${pkgs.python312.withPackages (p: [
        p.pygobject3
        p.openai
        p.lark
        p.pyparsing
        p.pygobject-stubs
      ])}/${pkgs.python3.sitePackages}";
    };
  };
}
