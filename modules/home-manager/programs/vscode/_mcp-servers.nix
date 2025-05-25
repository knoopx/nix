{
  pkgs,
  config,
  ...
}: {
  # "postgres" = {
  #   "command" = "${pkgs.nodejs}/bin/npx";
  #   "args" = [
  #     "-y"
  #     "@modelcontextprotocol/server-postgres"
  #     "postgresql://localhost/mydb"
  #   ];
  # };
  fetch = {
    command = "${pkgs.uv}/bin/uvx";
    args = ["mcp-server-fetch"];
  };
  memory = {
    command = "${pkgs.nodejs}/bin/npx";
    args = ["-y" "@modelcontextprotocol/server-memory"];
  };
  time = {
    command = "${pkgs.uv}/bin/uvx";
    args = ["mcp-server-time" "--local-timezone=Europe/Madrid"];
  };
  playwright = {
    command = "${pkgs.nodejs}/bin/npx";
    args = [
      "@playwright/mcp@latest"
      # "--browser firefox"
      # "--headless"
      # "--vision"
    ];
  };
  console-ninja = {
    command = "npx";
    args = [
      "-y"
      "-c"
      "node ~/.console-ninja/mcp/"
    ];
  };
  puppeteer = {
    command = "${pkgs.nodejs}/bin/npx";
    args = ["-y" "@modelcontextprotocol/server-puppeteer"];
  };

  documents = {
    command = "${pkgs.nodejs}/bin/npx";
    args = ["-y" "@modelcontextprotocol/server-filesystem" "${config.home.homeDirectory}/Documents"];
  };

  # "github": {
  #   "command": "/bin/sh",
  #   "args":  ["-c", "PATH=/run/current-system/sw/bin:$PATH exec npx -y @modelcontextprotocol/server-github ${documents_dir}"],
  #   "env": {
  #     "GITHUB_PERSONAL_ACCESS_TOKEN": "${githubToken}"
  #   }
  # },
  # "git": {
  #   "command": "/bin/sh",
  #   "args": ["-c", "PATH=/run/current-system/sw/bin:$PATH exec uvx mcp-server-git --repository ${documents_dir}"]
  # }

  # servers.sitemcp-react = {
  #   command = "${pkgs.nodePackages.sitemcp}/bin/sitemcp";
  #   args = [
  #     "https://react.dev/reference/react"
  #     "--concurrency"
  #     "10"
  #   ];
  # };

  # servers.sitemcp-tailwindcss = {
  #   command = "${pkgs.nodePackages.sitemcp}/bin/sitemcp";
  #   args = [
  #     "https://tailwindcss.com/docs/"
  #     "--concurrency"
  #     "10"
  #   ];
  # };

  # servers.sitemcp-pytorch = {
  #   command = "${pkgs.nodePackages.sitemcp}/bin/sitemcp";
  #   args = [
  #     "https://pytorch.org/docs/stable/index.html"
  #     "--concurrency"
  #     "10"
  #   ];
  # };
}
