{lib, ...}:
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
    sound = mkOption {
      type = types.bool;
      description = "Enable or disable system sound";
      default = true;
    };
    bluetooth = mkOption {
      type = types.bool;
      description = "Enable or disable Bluetooth support";
      default = false;
    };
    wifi = mkOption {
      type = types.bool;
      description = "Enable or disable WiFi support";
      default = false;
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
