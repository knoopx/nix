{...}: {
  programs = {
    fish.enable = true;

    command-not-found = {
      enable = true;
    };

    fzf.fuzzyCompletion = true;
    skim.fuzzyCompletion = true;
  };
}
