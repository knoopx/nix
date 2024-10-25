{...}: {
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
      "io.github.zen_browser.zen"

      "com.belmoussaoui.Authenticator"
      "org.gnome.seahorse.Application"
      "org.gnome.World.Secrets"

      "com.github.maoschanz.drawing"
      "org.inkscape.Inkscape"

      "org.gnome.Calendar"
      "org.gnome.Decibels"
      "org.gnome.Evince"
      "org.gnome.FileRoller"

      "org.gnome.Showtime"
      # "io.mpv.Mpv"

      "org.gnome.baobab"

      "org.gnome.Loupe"
      # "org.gnome.eog"

      "net.nokyan.Resources"
      "org.gnome.gitg"
      "re.sonny.Commit"

      "org.gnome.Snapshot"

      # "org.gnome.World.PikaBackup"
      "org.jdownloader.JDownloader"
      "org.nicotine_plus.Nicotine"
      "org.onlyoffice.desktopeditors"
      "com.github.qarmin.czkawka"
      "com.github.tchx84.Flatseal"
      "com.github.wwmm.easyeffects"
      "com.jeffser.Alpaca"
      "com.prusa3d.PrusaSlicer"
      "com.transmissionbt.Transmission"
      "io.github.f3d_app.f3d"
      "io.gitlab.adhami3310.Impression"
      "io.otsaloma.nfoview"
      "net.sapples.LiveCaptions"
    ];
  };
}
