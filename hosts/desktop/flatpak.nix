_: {
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;

    update = {
      onActivation = true;
      auto = {
        enable = true;
        onCalendar = "daily";
      };
    };

    packages = [
      # "com.github.qarmin.czkawka"
      # "com.github.tchx84.Flatseal"
      # "com.jeffser.Alpaca"
      # "com.transmissionbt.Transmission"
      # "io.github.f3d_app.f3d"
      # "io.gitlab.adhami3310.Impression"
      # "io.otsaloma.nfoview"
      # "net.nokyan.Resources"
      # "net.sapples.LiveCaptions"

      # "com.github.wwmm.easyeffects"
      # "org.gnome.baobab"
      # "org.gnome.Calendar"
      # "org.gnome.Decibels"
      # "org.gnome.Evince"
      # "org.gnome.FileRoller"
      # "org.gnome.gitg"
      # "org.gnome.Loupe"
      # "org.gnome.Showtime"
      # "org.gnome.Snapshot"

      # "re.sonny.Commit"
      "org.jdownloader.JDownloader"
      # "org.nicotine_plus.Nicotine"
      # "org.onlyoffice.desktopeditors"
      # "com.belmoussaoui.Authenticator"
      # "com.github.maoschanz.drawing"
      # "com.prusa3d.PrusaSlicer"
      # "io.github.zen_browser.zen"
      # "io.mpv.Mpv"
      # "org.gnome.eog"
      # "org.gnome.seahorse.Application"
      # "org.gnome.World.PikaBackup"
      # "org.gnome.World.Secrets"
      # "org.inkscape.Inkscape"
    ];
  };
}
