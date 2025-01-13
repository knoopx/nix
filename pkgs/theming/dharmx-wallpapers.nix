{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "dharmx-wallpapers";
  src = pkgs.fetchFromGitHub {
    owner = "dharmx";
    repo = "walls";
    rev = "6bf4d733ebf2b484a37c17d742eb47e5139e6a14";
    sha256 = "sha256-M96jJy3L0a+VkJ+DcbtrRAquwDWaIG9hAUxenr/TcQU=";
  };

  # TODO: make them show in gnome settings
  installPhase = ''
    mkdir -p $out/share/backgrounds/gnome
    ln -s $src $out/share/backgrounds/gnome/dharmx

    # for file in **/*.{jpg,png}; do
    #   category=$(basename "$(dirname "$file")")
    #   base=$(basename "$file")
    #   ln -s "$file" "$out/share/backgrounds/$category-$base"
    # done
  '';
}
