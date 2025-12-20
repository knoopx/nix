{pkgs, ...}: let
  vbtFirmware = pkgs.runCommand "firmware-vbt-patched" {} ''
    mkdir -p $out/lib/firmware
    cp "${./vbt_patched.bin}" $out/lib/firmware/vbt
  '';
in {
  hardware.firmware = [vbtFirmware];
  boot.initrd.kernelModules = ["i915"];
  boot.initrd.extraFirmwarePaths = ["vbt"];
  boot.kernelParams = ["quiet" "i915.vbt_firmware=vbt"];
}
