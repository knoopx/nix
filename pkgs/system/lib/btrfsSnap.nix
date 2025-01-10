{pkgs, ...}: let
  btrfsMountName = mount-point: builtins.replaceStrings ["/"] [""] mount-point;

  btrfsSnapServiceName = mount-point: interval: "btrfs-snapshot-${btrfsMountName mount-point}-${interval}";

  btrfsSnapService = mount-point: prefix: count: {
    description = "BTRFS snapshot ${mount-point} (${prefix})";
    path = with pkgs; [
      btrfs-snap
      utillinux
      perl
      btrfs-progs
    ];
    script = "btrfs-snap -r ${mount-point} ${prefix} ${toString count}";
  };

  btrfsSnapTimer = mount-point: interval: {
    description = "BTRFS snapshot ${mount-point} (${interval})";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = interval;
      Persistent = true;
      Unit = "${btrfsSnapServiceName mount-point interval}.service";
    };
  };
in {
  inherit
    btrfsSnapServiceName
    btrfsSnapService
    btrfsSnapTimer
    ;
}
