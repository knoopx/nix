{ pkgs, config, ... }: {
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    bluetooth = {
      enable = config.defaults.bluetooth;
      powerOnBoot = config.defaults.bluetooth;
    };
  };

  environment.systemPackages = with pkgs; [
    bluez # Bluetooth protocol stack (Linux)
    bluez-tools # Additional Bluetooth utilities (bluetoothd, etc.)
    dmidecode # Hardware information from DMI/SMBIOS tables
    lshw # Hardware lister (detailed system hardware info)
    ntfs3g # NTFS3 filesystem driver
    pciutils # PCI device utilities (lspci)
    usbutils # USB device utilities (lsusb)
  ];
}
