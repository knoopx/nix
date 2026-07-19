{ lib, ... }:
with lib; {
  options.defaults.firefox = {
    userChrome = mkOption {
      type = types.bool;
      default = true;
      description = "Enable userChrome CSS customization";
    };
    userContent = mkOption {
      type = types.bool;
      default = true;
      description = "Enable userContent CSS customization";
    };
    extensions = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Firefox extensions";
    };
    policies = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Firefox policies";
    };
    searchEngines = mkOption {
      type = types.bool;
      default = true;
      description = "Enable custom search engines";
    };
    nativeMessaging = mkOption {
      type = types.bool;
      default = true;
      description = "Enable native messaging hosts (brotab)";
    };
  };

  config.defaults.firefox = {
    userChrome = true;
    userContent = true;
    extensions = true;
    policies = true;
    searchEngines = true;
    nativeMessaging = true;
  };
}
