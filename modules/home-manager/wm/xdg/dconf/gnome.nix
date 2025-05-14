{defaults, ...}: {
  dconf.settings = {
    "org/gnome/evolution/calendar" = {
      prefer-new-item = "";
      use-24hour-format = true;
      week-start-day-name = "monday";
      work-day-monday = true;
      work-day-tuesday = true;
      work-day-wednesday = true;
      work-day-thursday = true;
      work-day-friday = true;
      work-day-saturday = false;
      work-day-sunday = false;
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = defaults.display.sidebarWidth;
      window-width = builtins.elemAt defaults.display.windowSize 0;
      window-height = builtins.elemAt defaults.display.windowSize 1;
    };
  };
}
