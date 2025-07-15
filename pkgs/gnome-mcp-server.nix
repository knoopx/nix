{
  pkgs,
  lib,
  ...
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "gnome-mcp-server";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "gnome-mcp-server";
    rev = "main";
    hash = "sha256-1dhCeB0v0QK9QSSTv+huZfDSr/FpKkkaS2v+KrevyIU=";
  };

  cargoHash = "sha256-OC4gQaqmgKUBKRb+UgLXgcY0UclFjE8ByjuitfBizSI=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    rustc
    cargo
    wrapGAppsHook
  ];

  buildInputs = with pkgs; [
    glib
    gtk3
    dbus
    libdbusmenu
    # Add more if build fails and requests them
  ];

  meta = with lib; {
    description = "Model Context Protocol (MCP) server for the GNOME desktop";
    homepage = "https://github.com/bilelmoussaoui/gnome-mcp-server";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };
}
