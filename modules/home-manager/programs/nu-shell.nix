{pkgs, ...}: let
  carapace_nu = pkgs.runCommandLocal "carapace.nu" {buildInputs = [pkgs.carapace];} ''
    carapace _carapace nushell >$out
  '';
in {
  programs.nushell = {
    enable = true;
    envFile = {
      text = ''
        source ${carapace_nu}
      '';
    };
  };
}
