{
  config,
  lib,
  pkgs,
  ...
}: let
  backupDir = config.services.androidBackup.backupDir;
  screenshotsDir = config.services.androidBackup.screenshotsDir;
  downloadsDir = config.services.androidBackup.downloadsDir;
  serialShort = config.services.androidBackup.serialShort;
  systemdServiceName = "android-backup";

  backupScript = ''
    #!/usr/bin/env bash
    export DISPLAY=:0
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
    export PATH="$PATH:${pkgs.libnotify}/bin"
    BACKUP_DIR="${backupDir}"
    SCREENSHOTS_DIR="${screenshotsDir}"
    DOWNLOADS_DIR="${downloadsDir}"
    notify-send "Android Backup" "Starting Android backup"

    (
    set -e
    set -x
    echo "[DEBUG] Starting Android backup script"
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$SCREENSHOTS_DIR"
    mkdir -p "$DOWNLOADS_DIR"
    adb wait-for-device 2>&1 | (grep -Ev "^(\* daemon not running; starting now at|\* daemon started successfully$)" || true)
    adb wait-for-device
    echo "[DEBUG] Starting adb pull backup"
    # List files on device
    adb shell ls -1 /sdcard/DCIM/Camera | while IFS= read -r file; do
      # Skip empty lines
      [ -z "$file" ] && continue
      # If file does not exist locally, pull it
      if [ ! -f "$BACKUP_DIR/$file" ]; then
        echo "[DEBUG] Pulling $file"
        adb pull "/sdcard/DCIM/Camera/$file" "$BACKUP_DIR/$file"
      else
        echo "[DEBUG] Skipping existing $file"
      fi
    done
      # Backup screenshots
      adb shell ls -1 /sdcard/Pictures/Screenshots | while IFS= read -r file; do
        # Skip empty lines
        [ -z "$file" ] && continue
        # If file does not exist locally, pull it
        if [ ! -f "$SCREENSHOTS_DIR/$file" ]; then
          echo "[DEBUG] Pulling screenshot $file"
          adb pull "/sdcard/Pictures/Screenshots/$file" "$SCREENSHOTS_DIR/$file"
        else
          echo "[DEBUG] Skipping existing screenshot $file"
        fi
      done
      # Backup downloads
      adb shell ls -1 /sdcard/Download | while IFS= read -r file; do
        # Skip empty lines
        [ -z "$file" ] && continue
        # If file does not exist locally, pull it
        if [ ! -f "$DOWNLOADS_DIR/$file" ]; then
          echo "[DEBUG] Pulling download $file"
          adb pull "/sdcard/Download/$file" "$DOWNLOADS_DIR/$file"
        else
          echo "[DEBUG] Skipping existing download $file"
        fi
      done
    echo "[DEBUG] Backup script finished"
    )

    if [ $? -ne 0 ]; then
      notify-send "Android Backup" "Backup terminated with errors. See journalctl --user -eu android-backup for details"
    else
      notify-send "Android Backup" "Backup terminated successfully"
    fi
  '';

  backupBin = pkgs.writeShellScriptBin "android-backup" backupScript;
in {
  options.services.androidBackup = {
    enable = lib.mkEnableOption "Enable Android photo backup on device connect";
    backupDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory to store backed up photos.";
    };
    screenshotsDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory to store backed up screenshots.";
    };
    downloadsDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory to store backed up downloads.";
    };
    serialShort = lib.mkOption {
      type = lib.types.str;
      description = "ID_SERIAL_SHORT of the Android device (from udev/lsusb).";
    };
  };

  config = lib.mkIf config.services.androidBackup.enable {
    environment.systemPackages = with pkgs; [android-tools libnotify curl backupBin];

    # Systemd user service definition
    systemd.user.services.${systemdServiceName} = {
      description = "Android Photo Backup";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${backupBin}/bin/android-backup";
      };
      path = [pkgs.android-tools pkgs.libnotify pkgs.curl];
    };

    # Udev rule to trigger the systemd user service
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEMS=="usb", ENV{ID_SERIAL_SHORT}=="${serialShort}", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="${systemdServiceName}.service"
    '';
  };
}
