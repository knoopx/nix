{config, ...}: let
  name = "chat";
in {
  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;

      image = "ghcr.io/open-webui/open-webui";

      volumes = [
        "open-webui:/app/backend/data"
      ];

      environment = {
        OLLAMA_BASE_URL = config.ai.baseURL;
        SCARF_NO_ANALYTICS = "True";
        WEBUI_AUTH = "False";
        ENABLE_SIGNUP = "False";
        ENABLE_RAG_WEB_SEARCH = "True";
        # RAG_WEB_SEARCH_ENGINE = "searxng";
        # SEARXNG_QUERY_URL = "https://search.knoopx.net/search?q=<query>";
        # RAG_EMBEDDING_ENGINE = "ollama";
        # RAG_EMBEDDING_MODEL = "mxbai-embed-large:latest";
      };
    };
  };
}
