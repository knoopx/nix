{ pkgs
, lib
, ...
}:

# CHUWI Hi10 Max DSDT override for the GC5035 front camera.
#
# The tablet's AMI DSDT gives the camera's I2C link device (LNK1) a sensor
# MCLK of L1CK (19.2 MHz) in its SSDB clock DWord. The GC5035 sensor needs
# 24 MHz, so the patched DSDT rewrites that DWord to 0x16E3600 (24 MHz).
#
# This package compiles the patched DSDT to AML (iasl) and packs it into an
# uncompressed cpio at kernel/firmware/acpi/ — the exact path the Linux
# kernel's ACPI table override (CONFIG_ACPI_TABLE_UPGRADE) reads from the
# initrd. Prepending this cpio via boot.initrd.prepend makes the kernel
# replace the BIOS DSDT during early boot, BEFORE any kernel module (incl.
# the camera stack) binds.
#
#   docs.kernel.org/admin-guide/acpi/initrd_table_override.html
#
# Source lives in hi10max-dsdt-src/ next to this file.

pkgs.stdenv.mkDerivation {
  pname = "hi10max-dsdt";
  version = "1.0";

  # No src tarball: the DSDT source is referenced directly via path
  # interpolation (Nix adds it as a build input automatically).
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.acpica-tools pkgs.cpio ];

  buildPhase = ''
    runHook preBuild

    # Compile in the build dir: iasl emits DSDT.aml next to the input file,
    # and the store input is read-only, so copy the DSDT source here first
    # (to an explicit filename, since `cp X .` is unreliable in the CWD).
    cp ${./hi10max-dsdt-src/DSDT.dsl} DSDT.dsl

    # iasl -tc tolerates the AMI DSDT's pre-existing warnings/remarks; the
    # only requirement is 0 errors.
    ${pkgs.acpica-tools}/bin/iasl -tc DSDT.dsl

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    # Pack the AML at the path the kernel's ACPI table override reads
    # (kernel/firmware/acpi/ inside an uncompressed cpio). The cpio is
    # prepended to the initrd by boot.initrd.prepend, so it must be the
    # first (uncompressed) archive the kernel scans.
    mkdir -p kernel/firmware/acpi
    cp DSDT.aml kernel/firmware/acpi/
    find kernel | sort | cpio --quiet -o -H newc -R +0:+0 --reproducible > $out/dsdt.cpio

    runHook postInstall
  '';

  meta = {
    description = "CHUWI Hi10 Max patched DSDT (GC5035 MCLKSPEED 24 MHz) as an initrd ACPI table override cpio";
    # The DSDT is the tablet's BIOS/AMI firmware.
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
