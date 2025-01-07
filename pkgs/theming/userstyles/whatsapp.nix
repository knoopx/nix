{pkgs, ...}:
pkgs.writeTextFile {
  name = "whatsapp.userstyle.css";
  text = ''
    @-moz-document domain("web.whatsapp.com") {
      .app-wrapper-web ._aigs:not(._as6h) {
        max-width: none;
        height: auto;
        top: 0;
        margin: 0;
        width: auto;
      }
    };
  '';
}
