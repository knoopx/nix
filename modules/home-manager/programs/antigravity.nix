{pkgs, ...} @ inputs: {
  # xdg.configFile."Code/User/prompts/" = {
  #   source = ./prompts;
  #   recursive = true;
  # };

  home.packages = with pkgs; [
    antigravity
  ];

  # programs = {
  #   antigravity = {
  #     enable = true;
  #     profiles.default = {
  #       extensions = import ./vscode/_extensions.nix inputs;
  #       keybindings = import ./vscode/_keybindings.nix;
  #       userSettings = import ./vscode/_user-settings.nix inputs;
  #     };
  #   };
  # };
}
