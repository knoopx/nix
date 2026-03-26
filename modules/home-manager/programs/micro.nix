{
  nixosConfig,
  lib,
  ...
}: let
  palette = nixosConfig.defaults.colorScheme.palette;
in {
  programs.micro = {
    enable = true;

    settings = {
      colorscheme = lib.mkForce "custom";
    };
  };

  xdg.configFile."micro/colorschemes/custom.micro".text = ''
    color-link default "#${palette.base05},#${palette.base00}"
    color-link comment "#${palette.base03},#${palette.base00}"
    color-link comment.bright "#${palette.base04},#${palette.base00}"
    color-link identifier "#${palette.base0E},#${palette.base00}"
    color-link identifier.class "#${palette.base08},#${palette.base00}"
    color-link identifier.macro "#${palette.base0D},#${palette.base00}"
    color-link identifier.var "#${palette.base06},#${palette.base00}"
    color-link constant "#${palette.base0B},#${palette.base00}"
    color-link constant.bool "#${palette.base09},#${palette.base00}"
    color-link constant.bool.true "#${palette.base0B},#${palette.base00}"
    color-link constant.bool.false "#${palette.base08},#${palette.base00}"
    color-link constant.number "#${palette.base0F},#${palette.base00}"
    color-link constant.specialChar "#${palette.base09},#${palette.base00}"
    color-link constant.string "#${palette.base0B},#${palette.base00}"
    color-link constant.string.url "#${palette.base0D},#${palette.base00}"
    color-link statement "#${palette.base0D},#${palette.base00}"
    color-link symbol "#${palette.base05},#${palette.base00}"
    color-link symbol.brackets "#${palette.base04},#${palette.base00}"
    color-link symbol.operator "#${palette.base0A},#${palette.base00}"
    color-link symbol.tag "#${palette.base0C},#${palette.base00}"
    color-link preproc "#${palette.base0F},#${palette.base00}"
    color-link preproc.shebang "#${palette.base02},#${palette.base00}"
    color-link type "#${palette.base0C},#${palette.base00}"
    color-link type.keyword "#${palette.base0D},#${palette.base00}"
    color-link special "#${palette.base0E},#${palette.base00}"
    color-link underlined "#${palette.base0F},#${palette.base01}"
    color-link error "bold #${palette.base08},#${palette.base00}"
    color-link todo "bold #${palette.base0A},#${palette.base00}"
    color-link statusline "#${palette.base0D},#${palette.base01}"
    color-link tabbar "#${palette.base06},#${palette.base01}"
    color-link indent-char "#${palette.base03},#${palette.base00}"
    color-link line-number "#${palette.base04},#${palette.base01}"
    color-link gutter-error "#${palette.base08},#${palette.base03}"
    color-link gutter-warning "#${palette.base09},#${palette.base03}"
    color-link cursor-line "#${palette.base01}"
    color-link current-line-number "#${palette.base05},#${palette.base03}"
    color-link color-column "#${palette.base03}"
    color-link ignore "#${palette.base06},#${palette.base03}"
    color-link divider "#${palette.base03}"
  '';
}
