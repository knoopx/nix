{ config
, lib
, pkgs
, ...
}:

# Boot-time DSDT override for the GC5035 front camera.
#
# Uses the kernel's ACPI table override (CONFIG_ACPI_TABLE_UPGRADE): the
# patched DSDT.aml is packed into an uncompressed cpio at
# kernel/firmware/acpi/ and prepended to the initrd via boot.initrd.prepend.
# The kernel reads those tables during early boot and replaces the BIOS DSDT
# BEFORE any kernel module binds, so the patched LNK1 SSDB (MCLKSPEED
# 24 MHz) is in effect when intel_skl_int3472_discrete / ipu-bridge / gc5035
# probe. This is strictly earlier than a userspace systemd override could
# ever run, and needs no root mount.
#
#   docs.kernel.org/admin-guide/acpi/initrd_table_override.html
#
# The patch changes only the LNK1 SSDB clock DWord (19.2 MHz -> 24 MHz); it
# does NOT address the separate INT3472 pinctrl / regulator gap that also
# blocks the sensor.

{
  # Enable the kernel facility that scans the initrd for ACPI tables.
  # (No-op if the booted kernel already enables ACPI_TABLE_UPGRADE.)
  boot.kernelPatches = [
    {
      name = "acpi-table-upgrade";
      patch = null;
      extraConfig = "ACPI_TABLE_UPGRADE y";
    }
  ];

  # Prepend the DSDT cpio so the kernel loads it as the very first initrd
  # archive (the uncompressed part the ACPI table override reads). The
  # package is host-local (imported, not a flake package).
  boot.initrd.prepend = [
    "${import ./hi10max-dsdt.nix { inherit pkgs lib; }}/dsdt.cpio"
  ];
}
