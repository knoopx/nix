{
  pkgs,
  defaults,
  inputs,
  system,
  ...
}: let
  dev-tools = with pkgs; [
    alejandra
    bun
    cargo
    docker-compose
    libsecret
    nil
    nixd
    nodejs
    python3
    ruby
    shfmt
    tealdeer
    tokei
    uv
  ];

  gtk-apps = with pkgs; [
    authenticator
    commit
    eog
    firefox
    gitg
    gnome.gnome-control-center
    inputs.nix-software-center.packages.${system}.nix-software-center
    kitty
    nautilus
    seahorse
    xdg-desktop-portal-gnome
  ];

  chromium-apps = with pkgs; [
    google-chrome
    vscode
  ];
in {
  imports = [
    ./defaults.nix
    ./knoopx/services.nix
    # TODO: include only if gnome enabled
    ./knoopx/gnome-conf.nix
  ];

  home = {
    username = "knoopx";
    homeDirectory = "/home/knoopx";
    packages =
      dev-tools
      ++ gtk-apps
      ++ (map (
          pkg: (pkg.override
            {
              commandLineArgs = [
                "--ozone-platform-hint=auto"
                "--disable-features=WaylandFractionalScaleV1"
                "--enable-features=WaylandWindowDecorations"
              ];
            })
        )
        chromium-apps)
      ++ defaults.gnome.extensions;
  };
}
