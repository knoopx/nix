{pkgs, ...}:
pkgs.python311.pkgs.buildPythonApplication rec {
  pname = "lora-inspector";
  version = "0.2";

  pyproject = true;

  nativeBuildInputs = [
    pkgs.python311Packages.poetry-core
  ];

  dependencies = with pkgs.python311Packages; [
    numpy
    pillow
    safetensors
    wandb
  ];

  src = fetchTarball {
    url = "https://github.com/rockerBOO/lora-inspector/archive/refs/tags/${version}.zip";
    sha256 = "sha256:0d40wgmk1chs6l02dm0nz1xd60zq6d1r935rsh88m4c8nb5wzl8f";
  };

  preConfigure = ''
    substituteInPlace pyproject.toml --replace-fail "readme = \"README.md\"" "packages = [{ include = \"lora-inspector.py\" }]"
  '';
}
