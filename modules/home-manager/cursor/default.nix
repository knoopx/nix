{
  pkgs,
  config,
  ...
}: {
  imports = [
    "./cursor.nix"
  ];

  stylix.targets.code-cursor.profileNames = ["default"];
  code-cursor = {
    enable = true;
    package = (
      pkgs.code-cursor.overrideAttrs
      (prev: {
        installPhase =
          prev.installPhase
          + ''
            rm $out/bin/cursor
            mv $out/bin/.cursor-wrapped $out/bin/cursor
            wrapProgram $out/bin/cursor --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --disable-features=WaylandFractionalScaleV1 --no-update"
          '';
      })
    );
    extensions = config.programs.vscode.profiles.default.extensions;
    keybindings = config.programs.vscode.profiles.default.keybindings;
    userSettings = config.programs.vscode.profiles.default.userSettings;
  };
}
