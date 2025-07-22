# nix-chuwi-minibook-x

This flake provides NixOS and Home Manager modules for the Chuwi Minibook X N150 device. It aims to deliver a smooth out-of-the-box experience for this hardware, including device-specific tweaks, hardware enablement, and user experience improvements.


## Modules

### NixOS: `hardware.chuwi-minibook-x`

This module provides device-specific configuration for the Chuwi MiniBook X N150, including hardware enablement and automatic display rotation support.

#### Options

- **`hardware.chuwi-minibook-x.enable`** (boolean)
  - Enables all Chuwi MiniBook X specific configurations, including hardware sensor support and display rotation integration.

- **`hardware.chuwi-minibook-x.autoDisplayRotation.enable`** (boolean, default: `true`)
  - Enables automatic display rotation based on accelerometer data. When enabled, the following are configured:
    - `hardware.sensor.iio` (enables IIO sensor support)
    - `systemd.services.iio-sensor-proxy` (ensures the sensor proxy is started)
    - `services.minibook-dual-accelerometer` (custom service for orientation detection)

##### Example

```nix
hardware.chuwi-minibook-x = {
  enable = true;
  autoDisplayRotation.enable = true;
};
```

#### Effect

When enabled, this module ensures that the necessary kernel modules, services, and accelerometer-based rotation are set up for the device. For user-level display rotation commands, see the Home Manager module below.

---

### Home Manager: `hardware.chuwi-minibook-x.autoDisplayRotation`

This module enables automatic display rotation based on accelerometer data, using `iio-sensor-proxy` and `niri` for display management. It provides a systemd user service and a configurable set of shell commands for each detected orientation.

#### Options

- **`hardware.chuwi-minibook-x.autoDisplayRotation.commands`** (submodule)
  - **`normal`** (string, default: `niri msg output "DSI-1" transform normal`)
    - Shell command to run when orientation is normal.
  - **`bottomUp`** (string, default: `niri msg output "DSI-1" transform 180`)
    - Shell command to run when orientation is bottom-up (inverted).
  - **`rightUp`** (string, default: `niri msg output "DSI-1" transform 270`)
    - Shell command to run when orientation is right-up (rotated right).
  - **`leftUp`** (string, default: `niri msg output "DSI-1" transform 90`)
    - Shell command to run when orientation is left-up (rotated left).

Each value should be a shell command string. The defaults match the current niri usage for the DSI-1 output.

##### Example

```nix
hardware.chuwi-minibook-x.autoDisplayRotation = {
  enable = true;
  commands = {
    normal = "echo 'normal'";
    bottomUp = "echo 'bottom-up'";
    rightUp = "echo 'right-up'";
    leftUp = "echo 'left-up'";
  };
};
```

#### Service

When enabled, this module provides a user systemd service named `auto-display-rotation` that listens for orientation changes and executes the configured commands.

---

## Contributing

Contributions and improvements are welcome! Please see the main repository for guidelines.

## License

See the repository for license information.
