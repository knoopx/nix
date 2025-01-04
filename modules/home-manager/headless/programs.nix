{pkgs, ...}: {
  stylix.targets.kde.enable = false;

  home.packages = [
    (pkgs.writeShellScriptBin "caffeine-on" ''
      gsettings --schemadir /etc/profiles/per-user/$USER/share/gnome-shell/extensions/caffeine@patapon.info/schemas/ set org.gnome.shell.extensions.caffeine toggle-state true
    '')

    (pkgs.writeShellScriptBin "caffeine-off" ''
      gsettings --schemadir /etc/profiles/per-user/$USER/share/gnome-shell/extensions/caffeine@patapon.info/schemas/ set org.gnome.shell.extensions.caffeine toggle-state false
    '')

    (pkgs.writeShellScriptBin "caffeine-status" ''
      gsettings --schemadir /etc/profiles/per-user/$USER/share/gnome-shell/extensions/caffeine@patapon.info/schemas/ get org.gnome.shell.extensions.caffeine toggle-state
    '')

    (pkgs.writeShellScriptBin "mktoken" ''
      tr -dc A-Za-z0-9_ < /dev/urandom | head -c 32 | xargs
    '')

    # (pkgs.writeShellApplication {
    #   name = "fzf-music";
    #   text = ''
    #     set -l root_dir /home/knoopx/Music/Library
    #     set -l starred_path $root_dir/.starred
    #     set -l cache_path $root_dir/.cache

    #     if not test -e $cache_path
    #         echo "Scanning library..."
    #         find -L $root_dir -type f -name "*.mp3" -print0 | xargs -0 dirname | uniq >$cache_path
    #     end

    #     set albums (cat $cache_path | awk -F/ '{print $NF "\t" $0}' | sort --ignore-case)

    #     set starred (cat $starred_path | awk -F/ '{print $NF "\t" $0}' | sort --ignore-case | awk '{print $2}')

    #     for album in $albums
    #         set path (string split \t $album)[-1]
    #         set index (contains -i $path $starred)
    #         if test -n "$index"
    #             set albums[$index] "★ $album"
    #         end
    #     end

    #     printf '%s\n' $albums | fzf --reverse \
    #         --bind="enter:execute(fzf-music-play {2})" \
    #         --bind="ctrl-s:execute(echo {2} >> $starred_path; cat $starred_path | sort -u -o $starred_path)" \
    #         # --bind="2:execute(fzf-music-starred)" \
    #         --bind='ctrl-r:reload:ps xjf' \
    #         --with-nth=1 --delimiter='\t' --preview 'fzf-music-preview {2}'
    #   '';
    # })
  ];

  programs = {
    home-manager = {
      enable = true;
    };

    # TODL https://nixos.wiki/wiki/CCache
    # ccache.enable = true;

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
    };

    yazi = {
      enable = true;

      # TODO

      settings = {
        manager = {
          # ratio = [1 2 4];
          # sort_dir_first = true;
          # linemode = "mtime";
        };

        preview = {
          # tab_size = 4;
          # image_filter = "lanczos3";
          # max_width = 1920;
          # max_height = 1080;
          # image_quality = 90;
        };
      };

      keymap = {
        manager.prepend_keymap = [
          # {
          #   run = "remove --force";
          #   on = ["d"];
          # }
        ];
      };
    };
  };
}
