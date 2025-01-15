{pkgs, ...}:
pkgs.writeTextFile {
  name = "devdocs.userstyle.css";
  text = ''
    @-moz-document domain("devdocs.io"), domain("gjs-docs.gnome.org") {
      html._theme-dark {
        --documentBackground: var(--base00);
        --contentBackground: var(--base00);
        --textColor: var(--base07);
        --textColorLight: var(--base05);
        --textColorLighter: var(--base05);
        --focusBackground: var(--base03);
        --focusBorder: var(--base01);
        --focusText: var(--base05);
        --loadingText: var(--base0D);
        --selectionBackground: var(--base02);
        --selectionBorder: var(--base01);
        --highlightBackground: var(--base04);
        --linkColorHover: var(--base07);
        --headerBackground: var(--base01);
        --headerBorder: var(--base01);
        --searchTagBackground: var(--base01);
        --searchBorder: var(--base01);
        --sidebarBackground: var(--base01);
        --sidebarBorder: var(--base01);
        --scrollbarColor: var(--base04);
        --scrollbarColorHover: var(--base04);
        --boxHeaderColor: var(--base05);
        --noteBackground: var(--base02);
        --noteBorder: var(--base01);
        --noteGreenBackground: var(--base02);
        --noteGreenBorder: var(--base01);
        --noteBlueBackground: var(--base03);
        --noteBlueBorder: var(--base01);
        --noteOrangeBackground: var(--base02);
        --noteOrangeBorder: var(--base01);
        --noteRedBackground: var(--base02);
        --noteRedBorder: var(--base01);
        --notifBackground: var(--base03);
        --notifBorder: 1px solid var(--base01);
      }
    }
  '';
}
