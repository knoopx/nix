{
  pkgs,
  lib,
  nixosConfig,
  ...
}: let
  settingsFormat = pkgs.formats.yaml {};
in {
  xdg.configFile."io.datasette.llm/extra-openai-models.yaml".source = settingsFormat.generate "extra-openai-models.yaml" (
    builtins.attrValues (builtins.mapAttrs (
        name: model: {
          model_id = name;
          model_name = name;
          aliases = model.aliases;
          api_base = "${nixosConfig.ai.baseURL}/v1";
        }
      ) (lib.filterAttrs (
          name: model: model.unlisted != true
        )
        nixosConfig.ai.models))
  );
}
