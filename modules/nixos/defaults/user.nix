{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.defaults = {
    username = mkOption {
      type = types.str;
      description = "Default username for the system";
    };
    password = mkOption {
      type = types.str;
      description = "Default password (same as username)";
    };
    fullName = mkOption {
      type = types.str;
      description = "Full name of the user";
    };
    location = mkOption {
      type = types.str;
      description = "User location";
    };
    primaryEmail = mkOption {
      type = types.str;
      description = "Primary email address";
    };
    avatarImage = mkOption {
      type = types.path;
      description = "User avatar image";
    };
    pubKeys = mkOption {
      type = types.path;
      description = "Public keys configuration";
    };
  };

  config = {
    defaults = {
      username = "knoopx";
      password = "knoopx";
      fullName = "Victor Martinez";
      location = "Vilassar de Mar";
      primaryEmail = "knoopx@gmail.com";
      avatarImage = pkgs.fetchurl {
        url = "https://avatars.githubusercontent.com/u/100993?s=512&u=1703477b683272ffb744f2d41d4b7599010d239b&v=4";
        sha256 = "sha256-bMHK0ZX9oZYJPI9FqYOcXMQonzipb0Hmbb4MnlhoiLY=";
      };
      pubKeys = pkgs.fetchurl {
        url = "https://github.com/${config.defaults.username}.keys";
        sha256 = "sha256-385krE9Aoea23aQ3FJo2kpPtRrIOwxxXCCt43gHEo0Q=";
      };
    };
  };
}
