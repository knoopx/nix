{lib, ...}: {
  path,
  colors,
  mode,
  width,
  height,
}: let
  splitPath = lib.splitString "~" path;

  makeStrokeFill = color:
    if mode == "fill"
    then "stroke='none' fill='#${color}'"
    else "stroke-width='1' stroke='#${color}' fill='none'";

  makeStrokeGroup =
    lib.concatImapStrings
    (
      idx: p: (lib.replaceStrings ["/>"] [" ${makeStrokeFill (builtins.elemAt colors (idx + 1))} />"] p)
    )
    splitPath;

  widthString = toString (width * 100);
  heightString = toString (height * 100);

  patternSvg = ''
    <svg xmlns='http://www.w3.org/2000/svg' width='${widthString}' height='${heightString}'>
      ${makeStrokeGroup}
    </svg>
  '';
in ''
  background-color: #${builtins.head colors};
  background-image: url("data:image/svg+xml,${lib.strings.escapeURL patternSvg}");
''
