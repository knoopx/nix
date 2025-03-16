{
  pkgs,
  config,
  defaults,
  lib,
  ...
}: {
  imports = [
    ./easy-effects.nix
    ./firefox
    ./fish.nix
    ./gaming.nix
    ./terminal.nix
    ./git.nix
    ./gnome
    ./kitty.nix
    ./navi
    ./cursor.nix
    ./yazi.nix
    ./shamls
  ];

  home.packages = with pkgs; [
    fuzzy
    fuzzel
    webkit-shell
    shttp
  ];

  stylix.targets.vscode.profileNames = ["default"];

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 5d --keep 3";
      flake = "${config.home.homeDirectory}/.dotfiles";
    };

    vscode = {
      enable = true;
      package =
        pkgs.vscode.override
        {
          commandLineArgs = [
            "--disable-features=WaylandFractionalScaleV1"
          ];
        };

      profiles.default = {
        keybindings = import ./vscode/keybindings.nix {};
        userSettings = import ./vscode/user-settings.nix {inherit pkgs defaults lib config;};
      };
    };

    # stylix.targets.code-cursor.profileNames = ["default"];
    # code-cursor = {
    #   enable = true;
    #   package = (
    #     pkgs.code-cursor.overrideAttrs
    #     (prev: {
    #       # --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}
    #       installPhase =
    #         prev.installPhase
    #         + ''
    #           rm $out/bin/cursor
    #           mv $out/bin/.cursor-wrapped $out/bin/cursor
    #           wrapProgram $out/bin/cursor --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --disable-features=WaylandFractionalScaleV1 --no-update"
    #         '';
    #     })
    #   );
    #   extensions = config.programs.vscode.profiles.default.extensions;
    #   keybindings = config.programs.vscode.profiles.default.keybindings;
    #   userSettings = config.programs.vscode.profiles.default.userSettings;
    # };
  };
}
