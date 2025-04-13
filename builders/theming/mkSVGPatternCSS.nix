{lib, ...}: {
  path,
  colors,
  mode,
  width,
  height,
  scale ? 1,
}: let
  splitPath = lib.splitString "~" path;

  makeStrokeFill = color:
    if mode == "fill"
    then ''stroke="none" fill="#${color}"''
    else ''stroke-width="${toString scale}" stroke="#${color}" fill="none"'';

  makeStrokeGroup =
    lib.concatImapStrings
    (
      idx: p: (lib.replaceStrings ["/>"] [" ${makeStrokeFill (builtins.elemAt colors idx)} />"] p)
    )
    splitPath;

  widthString = toString width;
  heightString = toString height;

  patternSvg = ''
    <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" fill="#${builtins.head colors}">
      <pattern id="p" patternUnits="userSpaceOnUse" width="${widthString}" height="${heightString}" patternTransform="scale(${toString scale})">
        ${makeStrokeGroup}
      </pattern>
      <rect width="100%" height="100%" fill="url(#p)" />
    </svg>
  '';
in ''
  background-color: #${builtins.head colors};
  background-size: ${toString (width * scale)}px ${toString (height * scale)}px;
  background-image: url("data:image/svg+xml,${lib.strings.escapeURL patternSvg}");
''
