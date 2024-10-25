{pkgs, ...}: let
  btrfs-mount-name = mount-point: builtins.replaceStrings ["/"] [""] mount-point;
  btrfs-snap-service-name = mount-point: interval: "btrfs-snapshot-${btrfs-mount-name mount-point}-${interval}";

  btrfs-snap-service = mount-point: prefix: count: {
    description = "BTRFS snapshot ${mount-point} (${prefix})";
    path = with pkgs; [
      btrfs-snap
      utillinux
      perl
      btrfs-progs
    ];
    script = "btrfs-snap -r ${mount-point} ${prefix} ${toString count}";
  };

  btrfs-snap-timer = mount-point: interval: {
    description = "BTRFS snapshot ${mount-point} (${interval})";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = interval;
      Persistent = true;
      Unit = "${btrfs-snap-service-name mount-point interval}.service";
    };
  };

  mount-point = "/home";
in {
  systemd = {
    services = {
      "${btrfs-snap-service-name mount-point "hourly"}" = btrfs-snap-service mount-point "hourly" 12;
      "${btrfs-snap-service-name mount-point "daily"}" = btrfs-snap-service mount-point "daily" 7;
      "${btrfs-snap-service-name mount-point "weekly"}" = btrfs-snap-service mount-point "weekly" 1;
    };

    timers = {
      "${btrfs-snap-service-name mount-point "hourly"}" = btrfs-snap-timer mount-point "hourly";
      "${btrfs-snap-service-name mount-point "daily"}" = btrfs-snap-timer mount-point "daily";
      "${btrfs-snap-service-name mount-point "weekly"}" = btrfs-snap-timer mount-point "weekly";
    };
  };
}
