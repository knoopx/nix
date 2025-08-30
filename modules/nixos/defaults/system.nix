{
  config,
  lib,
  ...
}:
with lib; {
  options.defaults = {
    keyMap = mkOption {
      type = types.str;
      description = "Keyboard layout mapping";
    };
    timeZone = mkOption {
      type = types.str;
      description = "System timezone";
    };
    defaultLocale = mkOption {
      type = types.str;
      description = "Default system locale";
    };
    region = mkOption {
      type = types.str;
      description = "Regional locale settings";
    };
    editor = mkOption {
      type = types.str;
      description = "Default text editor";
    };
  };

  config = {
    defaults = {
      keyMap = "eu";
      timeZone = "Europe/Madrid";
      defaultLocale = "en_US.UTF-8";
      region = "es_ES.UTF-8";
      editor = "re.sonny.Commit";
    };
  };
}