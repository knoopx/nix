{defaults, ...}: {
  programs = {
    git = {
      enable = true;
      userName = defaults.full-name;
      userEmail = defaults.primary-email;

      aliases = {
        d = "diff";
        co = "checkout";
        cp = "cherry-pick";
        l = "log --pretty=format:'%C(black)%h%Creset%C(red)%d%Creset %s %Cgreen(%cr) %C(black)%an%Creset' --abbrev-commit";
        b = "branch";
        bb = "branch -v";
        s = "status";
        g = "log --graph --pretty=format:'%Cgreen%h%Creset -%C(yellow)%d%Creset %s %C(black)(%cr)%Creset' --abbrev-commit --date=relative";
        unstage = "reset HEAD";
        reset-permissions = "git push origin devel help config  diff -p | grep -E '^(diff|old mode|new mode)' | sed -e 's/^old/NEW/;s/^new/old/;s/^NEW/new/' | git apply";
      };

      attributes = [
        "*.lockb binary diff=lockb"
      ];

      extraConfig = {
        color = {
          ui = true;
          diff = "auto";
          status = "auto";
          branch = "auto";
        };

        diff.lockb = {
          textconv = "bun";
          binary = true;
        };

        core = {
          inherit (defaults) editor;
          autocrlf = false;
          quotePath = false;
        };

        push = {
          default = "simple";
          autoSetupRemote = true;
        };

        pull.rebase = true;
        rebase.autoStash = true;
        filter.lfs.clean = "git-lfs clean -- %f";
        filter.lfs.smudge = "git-lfs smudge -- %f";
        filter.lfs.process = "git-lfs filter-process";
        filter.lfs.required = true;
        submodule.recurse = true;
        remote.origin.prune = true;
        init.defaultBranch = "main";
        rerere.enabled = true;

        branch = {
          autosetupmerge = true;
          autosetuprebase = "always";
        };

        advice = {
          statusHints = false;
          pushNonFastForward = false;
        };

        apply = {
          whitespace = "fix";
        };

        blame = {
          date = "relative";
        };

        credential = {
          helper = "store";
        };
      };

      diff-so-fancy.enable = true;
    };
  };
}
