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
  };

  "huggingface" = {
    "command" = "uvx";
    "args" = ["huggingface-mcp-server"];
  };

  "markitdown" = {
    "command" = "uvx";
    "args" = ["markitdown-mcp"];
  };

  "github" = {
    "command" = "docker";
    "args" = [
      "run"
      "-i"
      "--rm"
      "-e"
      "GITHUB_PERSONAL_ACCESS_TOKEN"
      "ghcr.io/github/github-mcp-server"
    ];
    "env" = {
      "GITHUB_PERSONAL_ACCESS_TOKEN" = "\${GITHUB_TOKEN}";
    };
  };

  # puppeteer = {
  #   command = "${pkgs.nodejs}/bin/npx";
  #   args = ["-y" "@modelcontextprotocol/server-puppeteer"];
  # };

  # "duckdb" = {
  #   "command" = "uvx";
  #   "args" = ["mcp-server-duckdb"];
  # };
}
