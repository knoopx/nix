{config, ...}: {
  # https://github.com/denisidoro/navi/blob/master/docs/
  # https://marketplace.visualstudio.com/items?itemName=yanivmo.navi-cheatsheet-language

  home.file.".local/share/navi/cheats/user" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/home-manager/navi/cheats";
  };

  programs.navi = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      # finder = {command = "skim";};
      shell = {
        command = "fish";
        finder_command = "fish";
      };
      style = {
        tag = {
          color = "yellow";
          width_percentage = 5;
          min_width = 10;
        };
        comment = {
          color = "blue";
          width_percentage = 30;
          min_width = 45;
        };
        snippet = {
          color = "dark_grey";
          min_width = 45;
        };
      };
    };
  };
}
