{pkgs, ...}: {
  hardware.display.edid.packages = [
    (pkgs.runCommandNoCC "firmware-custom-edid" {} ''
      mkdir -p $out/lib/firmware/edid/
      cp "${./90hz.bin}" $out/lib/firmware/edid/90hz.bin
    '')
  ];
  boot.kernelParams = ["quiet" "drm_kms_helper.edid_firmware=DSI-1:edid/90hz.bin"];
}
