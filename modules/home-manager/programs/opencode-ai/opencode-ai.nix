{
  pkgs,
  nixosConfig,
  ...
}: let
  generateTheme = colorScheme: {
    "$schema" = "https://opencode.ai/theme.json";
    defs = with colorScheme.palette; {
      base00 = "#${base00}";
      base01 = "#${base01}";
      base02 = "#${base02}";
      base03 = "#${base03}";
      base04 = "#${base04}";
      base05 = "#${base05}";
      base06 = "#${base06}";
      base07 = "#${base07}";
      base08 = "#${base08}";
      base09 = "#${base09}";
      base0A = "#${base0A}";
      base0B = "#${base0B}";
      base0C = "#${base0C}";
      base0D = "#${base0D}";
      base0E = "#${base0E}";
      base0F = "#${base0F}";
    };
    theme = {
      primary = {
        dark = "base0D";
        light = "base0D";
      };
      secondary = {
        dark = "base04";
        light = "base04";
      };
      accent = {
        dark = "base0A";
        light = "base0A";
      };
      error = {
        dark = "base08";
        light = "base08";
      };
      warning = {
        dark = "base09";
        light = "base09";
      };
      success = {
        dark = "base0B";
        light = "base0B";
      };
      info = {
        dark = "base0C";
        light = "base0C";
      };
      text = {
        dark = "base05";
        light = "base00";
      };
      textMuted = {
        dark = "base04";
        light = "base02";
      };
      background = {
        dark = "base00";
        light = "base07";
      };
      backgroundPanel = {
        dark = "base01";
        light = "base06";
      };
      backgroundElement = {
        dark = "base02";
        light = "base05";
      };
      border = {
        dark = "base03";
        light = "base03";
      };
      borderActive = {
        dark = "base0D";
        light = "base0D";
      };
      borderSubtle = {
        dark = "base02";
        light = "base02";
      };
      diffAdded = {
        dark = "base0B";
        light = "base0B";
      };
      diffRemoved = {
        dark = "base08";
        light = "base08";
      };
      diffContext = {
        dark = "base03";
        light = "base03";
      };
      diffHunkHeader = {
        dark = "base04";
        light = "base04";
      };
      diffHighlightAdded = {
        dark = "base0B";
        light = "base0B";
      };
      diffHighlightRemoved = {
        dark = "base08";
        light = "base08";
      };
      diffAddedBg = {
        dark = "base02";
        light = "base06";
      };
      diffRemovedBg = {
        dark = "base02";
        light = "base06";
      };
      diffContextBg = {
        dark = "base01";
        light = "base06";
      };
      diffLineNumber = {
        dark = "base03";
        light = "base04";
      };
      diffAddedLineNumberBg = {
        dark = "base02";
        light = "base06";
      };
      diffRemovedLineNumberBg = {
        dark = "base02";
        light = "base06";
      };
      markdownText = {
        dark = "base05";
        light = "base00";
      };
      markdownHeading = {
        dark = "base0D";
        light = "base0D";
      };
      markdownLink = {
        dark = "base0E";
        light = "base0E";
      };
      markdownLinkText = {
        dark = "base0C";
        light = "base0C";
      };
      markdownCode = {
        dark = "base0B";
        light = "base0B";
      };
      markdownBlockQuote = {
        dark = "base04";
        light = "base04";
      };
      markdownEmph = {
        dark = "base09";
        light = "base09";
      };
      markdownStrong = {
        dark = "base0A";
        light = "base0A";
      };
      markdownHorizontalRule = {
        dark = "base03";
        light = "base03";
      };
      markdownListItem = {
        dark = "base0D";
        light = "base0D";
      };
      markdownListEnumeration = {
        dark = "base0C";
        light = "base0C";
      };
      markdownImage = {
        dark = "base0E";
        light = "base0E";
      };
      markdownImageText = {
        dark = "base0C";
        light = "base0C";
      };
      markdownCodeBlock = {
        dark = "base05";
        light = "base00";
      };
      syntaxComment = {
        dark = "base04";
        light = "base03";
      };
      syntaxKeyword = {
        dark = "base0E";
        light = "base0E";
      };
      syntaxFunction = {
        dark = "base0D";
        light = "base0D";
      };
      syntaxVariable = {
        dark = "base08";
        light = "base08";
      };
      syntaxString = {
        dark = "base0B";
        light = "base0B";
      };
      syntaxNumber = {
        dark = "base09";
        light = "base09";
      };
      syntaxType = {
        dark = "base0A";
        light = "base0A";
      };
      syntaxOperator = {
        dark = "base0E";
        light = "base0E";
      };
      syntaxPunctuation = {
        dark = "base05";
        light = "base00";
      };
    };
  };
in {
  xdg.configFile."opencode/agent".source = ./agent;
  xdg.configFile."opencode/command".source = ./command;

  xdg.configFile."opencode/themes/custom.json".source =
    pkgs.writeText "custom.json" (builtins.toJSON (generateTheme nixosConfig.defaults.colorScheme));

  xdg.configFile."opencode/config.json".source = (pkgs.formats.json {}).generate "config.json" {
    "$schema" = "https://opencode.ai/config.json";
    theme = "tokyonight";
    autoupdate = false;
    share = "disabled";
    keybinds = {
      model_list = "ctrl+m";
    };
    mcp = {
      # sequential-thinking = {
      #   type = "local";
      #   command = ["bunx" "@modelcontextprotocol/server-sequential-thinking"];
      #   enabled = true;
      # };
      deepwiki = {
        type = "local";
        command = ["bunx" "mcp-deepwiki"];
        enabled = true;
      };
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        enabled = true;
      };
      github = {
        type = "local";
        command = ["podman" "run" "-i" "--rm" "-e" "GITHUB_PERSONAL_ACCESS_TOKEN" "ghcr.io/github/github-mcp-server"];
        enabled = true;
      };
      markitdown = {
        type = "local";
        command = ["uvx" "markitdown-mcp"];
        enabled = true;
      };
      open-websearch = {
        type = "local";
        command = ["bunx" "github:evanlouie/open-websearch"];
        enabled = true;
        environment = {
          MODE = "stdio";
        };
      };
    };
    # provider = {
    #   local = {
    #     npm = "@ai-sdk/openai-compatible";
    #     options = {
    #       baseURL = "${nixosConfig.defaults.ai.baseURL}/v1";
    #     };
    #     models =
    #       builtins.mapAttrs
    #       (name: model: {
    #         id = model.id;
    #         reasoning = model.reasoning;
    #         tool_call = model.tool_call;
    #         limit = {
    #           context = model.context;
    #           output = 0;
    #         };
    #       })
    #       (lib.filterAttrs (name: model: model.unlisted != true) nixosConfig.defaults.ai.models);
    #   };
    # };
  };
}
