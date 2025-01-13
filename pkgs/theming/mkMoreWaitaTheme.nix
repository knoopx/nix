{pkgs, ...}: colorScheme: let
  adwaita-colors = pkgs.fetchFromGitHub {
    owner = "dpejoh";
    repo = "Adwaita-colors";
    rev = "v2.4.1";
    sha256 = "sha256-M5dFb759sXfpD9/gQVF3sngyW4WdSgy4usInds9VIWk=";
  };

  folderColors = pkgs.theming.lib.colorVariations colorScheme.base05;
in
  pkgs.morewaita-icon-theme.overrideAttrs (prev: {
    # ${lib.getExe pkgs.theming.matchThemeColors} "$file" > "$file"
    postInstall = with folderColors; ''
      cp -r ${adwaita-colors}/Adwaita-blue/* $out/share/icons/MoreWaita

      substituteInPlace $out/share/icons/MoreWaita/scalable/**/{folder*,user-*,inode-directory}.svg \
        --replace-warn '#3f8ae5' '#${base0}' \
        --replace-warn '#438de6' '#${base0}' \
        --replace-warn '#62a0ea' '#${base1}' \
        --replace-warn '#a4caee' '#${base2}' \
        --replace-warn '#afd4ff' '#${base3}' \
        --replace-warn '#c0d5ea' '#${base4}' \
        --replace-warn '#1a5fb4' '#${base0}' \
        --replace-warn '#3584e4' '#${base1}' \
        --replace-warn '#3a87e5' '#${base1}' \
        --replace-warn '#99c1f1' '#${base2}' \
        --replace-warn '#c3e5e7' '#${base3}' \

      substituteInPlace $out/share/icons/MoreWaita/scalable/mimetypes/*.svg \
        --replace-warn '#50db81' '#${colorScheme.base0B}' \
        --replace-warn '#2ec27e' '#${colorScheme.base0B}' \
        --replace-warn '#82bfa1' '#${colorScheme.base0B}' \
        --replace-warn '#74ab28' '#${colorScheme.base0B}' \
        --replace-warn '#63b132' '#${colorScheme.base0B}' \
        --replace-warn '#a4c639' '#${colorScheme.base0B}' \
        --replace-warn '#399746' '#${colorScheme.base0B}' \
        --replace-warn '#f8981d' '#${colorScheme.base09}' \
        --replace-warn '#ff9a00' '#${colorScheme.base09}' \
        --replace-warn '#fb8c14' '#${colorScheme.base09}' \
        --replace-warn '#eb7b04' '#${colorScheme.base09}' \
        --replace-warn '#f96328' '#${colorScheme.base09}' \
        --replace-warn '#ca3c32' '#${colorScheme.base08}' \
        --replace-warn '#dd1100' '#${colorScheme.base08}' \
        --replace-warn '#e01b24' '#${colorScheme.base08}' \
        --replace-warn '#d72123' '#${colorScheme.base08}' \
        --replace-warn '#cc1018' '#${colorScheme.base08}' \
        --replace-warn '#be1a0d' '#${colorScheme.base08}' \
        --replace-warn '#9259a3' '#${colorScheme.base0C}' \
        --replace-warn '#8f5aa0' '#${colorScheme.base0C}' \
        --replace-warn '#726397' '#${colorScheme.base0C}' \
        --replace-warn '#8e62ff' '#${colorScheme.base0C}' \
        --replace-warn '#9999ff' '#${colorScheme.base0C}' \
        --replace-warn '#8f00ff' '#${colorScheme.base0C}' \
        --replace-warn '#787cb5' '#${colorScheme.base0C}' \
        --replace-warn '#6038cc' '#${colorScheme.base0C}' \
        --replace-warn '#39207c' '#${colorScheme.base0C}' \
        --replace-warn '#4a86cf' '#${colorScheme.base0D}' \
        --replace-warn '#55a7eb' '#${colorScheme.base0D}' \
        --replace-warn '#4a90d9' '#${colorScheme.base0D}' \
        --replace-warn '#306998' '#${colorScheme.base0D}' \
        --replace-warn '#1e64b6' '#${colorScheme.base0D}' \
        --replace-warn '#62a0ea' '#${colorScheme.base0D}' \
        --replace-warn '#31a8ff' '#${colorScheme.base0D}' \
        --replace-warn '#4768e8' '#${colorScheme.base0D}' \
        --replace-warn '#0000b2' '#${colorScheme.base0D}' \
        --replace-warn '#0073a1' '#${colorScheme.base0D}' \
        --replace-warn '#31a8ff' '#${colorScheme.base0D}' \
        --replace-warn '#007acc' '#${colorScheme.base0D}' \
        --replace-warn '#2a7bb1' '#${colorScheme.base0D}' \
        --replace-warn '#5382a1' '#${colorScheme.base0D}' \
        --replace-warn '#f6d32d' '#${colorScheme.base0E}' \
        --replace-warn '#fad000' '#${colorScheme.base0E}' \
        --replace-warn '#fdc00a' '#${colorScheme.base0E}' \
        --replace-warn '#faac28' '#${colorScheme.base0E}' \
        --replace-warn '#eaaa0d' '#${colorScheme.base0E}' \
        --replace-warn '#cdab8f' '#${colorScheme.base03}' \
        --replace-warn '#ae927a' '#${colorScheme.base04}' \
        --replace-warn '#ffffff' '#${colorScheme.base02}' \
        --replace-warn '#f6f5f4' '#${colorScheme.base04}' \
        --replace-warn '#e8e7e3' '#${colorScheme.base04}' \
        --replace-warn '#deddda' '#${colorScheme.base03}' \
        --replace-warn '#d5d3cf' '#${colorScheme.base02}' \
        --replace-warn '#c7c6c3' '#${colorScheme.base04}' \
        --replace-warn '#cbcac7' '#${colorScheme.base04}' \
        --replace-warn '#9a9996' '#${colorScheme.base04}' \
        --replace-warn '#949390' '#${colorScheme.base04}' \
        --replace-warn '#666666' '#${colorScheme.base04}' \
        --replace-warn '#45475a' '#${colorScheme.base05}' \
        --replace-warn '#414140' '#${colorScheme.base05}' \
        --replace-warn '#000000' '#${colorScheme.base05}' \

    '';
    # --replace-warn '#d3e3f9' '#${colorScheme.base03}' \
    # --replace-warn '#99c1f1' '#${colorScheme.base04}' \
  })
