{
  pkgs,
  colorScheme,
  ...
}:
pkgs.writeTextFile {
  name = "immich.userstyle.css";
  text = with colorScheme; ''
    @-moz-document domain("photos.knoopx.net") {
      .dark\:bg-immich-dark-bg  {
          background-color: #${base00};
      }

      .dark\:bg-immich-dark-gray {
          background-color: #${base01};
      }

      .dark\:bg-immich-dark-primary {
          background-color: #${base05};
      }
    }
  '';
}
