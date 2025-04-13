{
  btrfsSnapServiceName,
  btrfsSnapService,
  btrfsSnapTimer,
  lib,
  ...
}: let
  inherit (lib) mapAttrsToList zipAttrsWithNames;

  mount-point = "/home";
  config = {
    hourly = {
      interval = "hourly";
      count = 12;
    };

    daily = {
      interval = "daily";
      count = 7;
    };

    weekly = {
      interval = "weekly";
      count = 4;
    };
  };
  # zipAttrsWithNames ["a"] (name: vs: vs) [{a = "x";} {a = "y"; b = "z";}]
  # => { a = ["x" "y"]; }
  # names = mapAttrsToList (prefix: def: btrfsSnapServiceName mount-point def.interval) config;
  # services = zipAttrsWithNames names (prefix: def: (btrfsSnapService mount-point prefix def.interval)) config;
  # timers = zipAttrsWithNames names (prefix: def: (btrfsSnapTimer mount-point def.interval)) config;
in {
  systemd = {
    # services = services;
    # timers = zipAttrsWithNames names timers;
  };
}
