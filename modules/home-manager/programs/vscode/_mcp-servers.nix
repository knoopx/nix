{pkgs, ...}: {
  console-ninja = {
    command = "npx";
    args = [
      "-y"
      "-c"
      "node ~/.console-ninja/mcp/"
    ];
  };

  context7 = {
    type = "http";
    url = "https://mcp.context7.com/mcp";
  };

  "playwright" = {
    "command" = "bunx";
    "args" = [" @playwright/mcp@latest"];
  };

  "deepwiki" = {
    "command" = "bunx";
    "args" = ["mcp-deepwiki"];
    "trust" = true;
  };

  "huggingface" = {
    "command" = "uvx";
    "args" = ["huggingface-mcp-server"];
    "trust" = true;
  };

  "markitdown" = {
    "command" = "uvx";
    "args" = ["markitdown-mcp"];
    "trust" = true;
  };

  "github" = {
    "command" = "docker";
    "args" = [
      "run"
      "-i"
      "--rm"
      "-e"
      "GITHUB_PERSONAL_ACCESS_TOKEN"
      "-v"
      "$'{PWD}:/workspace"
      "ghcr.io/github/github-mcp-server"
    ];
    "env" = {
      "GITHUB_PERSONAL_ACCESS_TOKEN" = "$'{GH_TOKEN}";
    };
  };

  # puppeteer = {
  #   command = "${pkgs.nodejs}/bin/npx";
  #   args = ["-y" "@modelcontextprotocol/server-puppeteer"];
  # };

  # "duckdb" = {
  #   "command" = "uvx";
  #   "args" = ["mcp-server-duckdb"];
  #   "trust" = true;
  # };
}
