{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nfoview # .NFO file viewer (custom, GTK-based)
    nicotine-plus # SoulSeek P2P file-sharing client (GNOME)
    prusa-slicer # 3D printer G-code generator
    transmission_4-gtk # BitTorrent client (GTK/GNOME)
  ];
}
