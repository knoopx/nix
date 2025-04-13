{lib, ...}: basePath: let
  relPath = file: lib.removePrefix "/" (lib.removePrefix (toString basePath) (toString file));
  pathSegments = file: lib.splitString "/" (relPath file);
in
  lib.filter (
    file:
      lib.hasSuffix ".nix" file
      && lib.all (seg: !lib.hasPrefix "_" seg) (pathSegments file)
  ) (lib.filesystem.listFilesRecursive basePath)
