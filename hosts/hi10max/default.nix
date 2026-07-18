{ pkgs
, lib
, config
, ...
} @ inputs:
let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
  system = "x86_64-linux";
in
{
  imports =
    [
      ./boot.nix
      ./hardware.nix
      ./services.nix
      ../../modules/nixos/wm/xdg.nix
      ../../modules/nixos/wm/programs.nix
      ../../modules/nixos/wm/services.nix
    ]
    ++ (
      listNixModulesRecusive ../../modules/nixos/defaults
    )
    ++ (
      listNixModulesRecusive ../../modules/nixos/system
    )
    ++ (
      listNixModulesRecusive ../../modules/nixos/services
    )
    ++ (
      listNixModulesRecusive ../../modules/nixos/theming
    )
  ;

  programs.feedbackd.enable = true;
  hardware.sensor.iio.enable = true;

  # xdg.configFile."phosh/phoc.ini".text = ''
  #   [core]
  #   xwayland=true

  #   [output:*]
  #   scale = 1.5

  #   [output:Virtual-1]
  #   scale = 1.5

  #   [output:X11-1]
  #   mode = 1920x1080
  #   scale = 1.5

  #   [output:WL-1]
  #   mode = 1920x1080
  #   scale = 1.5
  # '';

  system.stateVersion = "25.11";

  networking.hostName = "hi10max";


  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  # Mobian-equivalent base, tablet/mobile packages and services for hi10max.
  environment.systemPackages = with pkgs; [
    # qt5.qtwayland
    # qt6.qtwayland
    # rygel
    squeekboard
    feedbackd
    iio-sensor-proxy
    gnome-settings-daemon
    xdg-desktop-portal-gtk
    gst123
    libcamera
    dconf
    alsa-utils
    busybox
    dosfstools
    e2fsprogs
    hwdata
    kbd
    rtkit
    usbutils
    iputils
    iptables
    iw
    nettools
    wirelesstools
    zstd
    bzip2
    dialog
    gawk
    less
    sudo
    bash-completion
    vim
    usb-modeswitch
  ];

  # Use compositor-provided input method (squeekboard) instead of IBus.
  # Required for squeekboard to receive input method activation events.
  # environment.variables = {
  #   GTK_IM_MODULE = lib.mkForce "wayland";
  #   QT_IM_MODULE = lib.mkForce "wayland";
  # };

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/a11y/applications" = { screen-keyboard-enabled = true; };
        "org/gnome/desktop/a11y/magnifier" = { cross-hairs-length = lib.gvariant.mkUint32 58; };
        "org/gnome/settings-daemon/plugins/media-keys" = { active = false; };
        "org/gnome/settings-daemon/plugins/power" = { active = false; };
        "org/gnome/settings-daemon/plugins/housekeeping" = { donation-reminder-enabled = false; };
        "org/gnome/settings-daemon/peripherals/touchscreen" = { orientation-lock = true; };
        "sm/puri/phoc" = { auto-maximize = true; osk-enabled = true; };
        "org/gnome/desktop/wm/preferences" = { button-layout = "appmenu:"; };
        "org/gnome/desktop/interface" = {
          cursor-blink = true;
          toolkit-accessibility = false;
          clock-show-seconds = false;
          clock-show-unicode = false;
          menu-animation = false;
          toolbar-style = "icons";
          icon-theme = "Adwaita-dark";
        };
        "org/gnome/desktop/input-sources" = { sources = lib.gvariant.mkArray [ "'xkb','us'" ]; };
        "org/sigxcpu/feedbackd" = { profile = "full"; };
        "org/gnome/control-center" = { last-panel = "universal-access"; };
        "org/gnome/settings-daemon/plugins/color" = { night-light-schedule-automatic = false; };
        "org/gnome/desktop/screensaver" = {
          lock-enabled = false;
          lock-delay = lib.gvariant.mkUint32 0;
        };
        "org/gnome/system/location" = { enabled = false; };
        "sm/puri/phosh/call" = { default-dialer = "chatty"; };
        "sm/puri/phosh/media-keys" = {
          next = "XF86AudioNext";
          play-pause = "XF86AudioPlay";
          previous = "XF86AudioPrev";
          stop = "XF86AudioStop";
        };
        "sm/puri/phosh" = { osk-enabled = true; };
        "sm/puri/phosh/osk" = { ignore-hw-keyboards = true; };
      };
    }
  ];

  # Squeekboard OSK is controlled via dconf:
  #   org/gnome/desktop/a11y/applications → screen-keyboard-enabled = true

  systemd.user.services."mobi.phosh.OSK" = {
    description = "Squeekboard on-screen keyboard";
    partOf = [ "mobi.phosh.OSK.target" ];
    serviceConfig = {
      Type = "simple";
      BusName = "sm.puri.OSK0";
      ExecStart = "${pkgs.squeekboard}/bin/squeekboard";
      Restart = "always";
    };
    wantedBy = [ "mobi.phosh.OSK.target" ];
  };

  # Mobian GNOME background config copied exactly.
  environment.etc."xdg/gnome-background-properties/custom.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
    <wallpapers>
      <wallpaper deleted="false">
        <name>Mobian Orange</name>
        <filename>/usr/share/backgrounds/custom/wallpaper.svg</filename>
        <options>zoom</options>
        <shade_type>solid</shade_type>
        <pcolor>#ff7800</pcolor>
      </wallpaper>
    </wallpapers>
  '';


  defaults.display.width = lib.mkForce 1920;
  defaults.display.height = lib.mkForce 1200;
  defaults.display.idleTimeout = lib.mkForce (15 * 60);
  defaults.display.idleTimeoutAC = lib.mkForce (15 * 60);
  defaults.display.defaultColumnWidthPercent = lib.mkForce 1.0;
  defaults.display.columnWidthPercentPresets = lib.mkForce [ 0.5 0.75 ];

  defaults.firefox.userChrome = lib.mkForce false;

  home-manager.users.${config.defaults.username} = {
    imports = [
      ../../home/${config.defaults.username}.nix
    ];
  };
}
