{pkgs, ...}:
pkgs.python3Packages.buildPythonApplication rec {
  pname = "ultralytics";
  version = "8.3.59";
  format = "wheel";

  dependencies = with pkgs.python3Packages; [
    numpy
    opencv4
    torch
    torchvision
    matplotlib
    psutil
    pytubefix
  ];

  src = pkgs.fetchurl {
    url = "https://files.pythonhosted.org/packages/13/7d/cc6718e94444fd882ce3d7f11137c11ee2198de1e6df87ae69c2c18dd360/ultralytics-${version}-py3-none-any.whl";
    sha256 = "sha256-INKcftVX3Mzty5cMS9p61vApiPgBr2rRQOW7CqPztVI=";
  };
}
