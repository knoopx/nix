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

  puppeteer = {
    command = "${pkgs.nodejs}/bin/npx";
    args = ["-y" "@modelcontextprotocol/server-puppeteer"];
  };
}
