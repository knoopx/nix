{
  pkgs,
  nixosConfig,
  ...
} @ inputs: {
  stylix.targets.vscode.profileNames = ["default"];

  xdg.configFile = builtins.listToAttrs (builtins.concatMap (path: [
    # {
    #   name = "${path}/User/globalStorage/rooveterinaryinc.roo-cline/settings/mcp_settings.json";
    #   value = { text = builtins.toJSON { servers = pkgs.callPackage ./_mcp-servers.nix inputs; }; };
    # }
    {
      name = "${path}/User/mcp.json";
      value = {text = builtins.toJSON {servers = nixosConfig.ai.mcp;};};
    }
    {
      name = "${path}/User/prompts/4.1-Beast.chatmode.md";
      value = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/github/awesome-copilot/refs/heads/main/chatmodes/4.1-Beast.chatmode.md";
          sha256 = "sha256-ISKHDpzTKN1h+MM0/E9f/wp6qfSSWp1rj9sqpVHKkR8=";
        };
      };
    }
  ]) ["Code" "Code - Insiders"]);

  programs = {
    vscode = {
      enable = true;
      profiles.default = {
        extensions = import ./_extensions.nix inputs;
        keybindings = import ./_keybindings.nix;
        userSettings = import ./_user-settings.nix inputs;
      };
    };
  };
}
