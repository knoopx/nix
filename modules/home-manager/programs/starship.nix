{...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;

    settings = {
      add_newline = true;
      format = "$all";
    };
  };
}
