{pkgs, ...}: {
  ai = {
    mcp = {
      sequential-thinking = {
        command = "bunx";
        args = ["@modelcontextprotocol/server-sequential-thinking"];
      };

      # {
      # 	"gallery": true,
      # 	"inputs": [
      # 		{
      # 			"name": "memory_file_path",
      # 			"type": "promptString",
      # 			"description": "Path to the memory storage file (optional)",
      # 			"password": false
      # 		}
      # 	],
      # 	"command": "npx",
      # 	"args": [
      # 		"-y",
      # 		"@modelcontextprotocol/server-memory"
      # 	],
      # 	"env": {
      # 		"MEMORY_FILE_PATH": "${input:memory_file_path}"
      # 	}
      # }

      # memory = {
      #   inputs = [
      #     {
      #       name = "memory_file_path";
      #       type = "promptString";
      #       description = "Path to the memory storage file (optional)";
      #       password = false;
      #     }
      #   ];
      #   command = "bunx";
      #   args = ["@modelcontextprotocol/server-memory"];
      #   env = {
      #     MEMORY_FILE_PATH = "''${input:memory_file_path}";
      #   };
      # };

      deepwiki = {
        command = "bunx";
        args = ["mcp-deepwiki"];
      };

      markitdown = {
        command = "uvx";
        args = ["markitdown-mcp"];
      };

      nixos = {
        command = "uvx";
        args = ["mcp-nixos"];
      };

      # playwright = {
      #   command = "bunx";
      #   args = [" @playwright/mcp@latest"];
      # };

      # context7 = {
      #   type = "http";
      #   url = "https://mcp.context7.com/mcp";
      # };

      # github = {
      #   command = "podman";
      #   args = [
      #     "run"
      #     "-i"
      #     "--rm"
      #     "-e"
      #     "GITHUB_PERSONAL_ACCESS_TOKEN"
      #     "ghcr.io/github/github-mcp-server"
      #   ];
      #   env = {
      #     GITHUB_PERSONAL_ACCESS_TOKEN = "\${GITHUB_TOKEN}";
      #   };
      # };

      # huggingface = {
      #   command = "uvx";
      #   args = ["huggingface-mcp-server"];
      # };

      # console-ninja = {
      #   command = "npx";
      #   args = [
      #     "-y"
      #     "-c"
      #     "node ~/.console-ninja/mcp/"
      #   ];
      # };

      # puppeteer = {
      #   command = "${pkgs.nodejs}/bin/npx";
      #   args = ["-y" "@modelcontextprotocol/server-puppeteer"];
      # };

      # duckdb = {
      #   command = "uvx";
      #   args = ["mcp-server-duckdb"];
      # };
    };
  };
}
