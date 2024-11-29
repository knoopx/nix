{
  pkgs,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation
rec {
  name = "myrient-dl";
  src = fetchGit {
    url = "https://github.com/Darkkid819/myrientDL";
    rev = "149748c514549c07ff1999e2b134e98604501f12";
  };

  venvDir = "./.venv";
  buildInputs = [
  ];

  nativeBuildInputs = with pkgs; [
    makeWrapper
    python3
    python3Packages.venvShellHook
  ];

  postVenvCreation = ''
    pip install -r requirements.txt
  '';
  # build-system = with pkgs.python3Packages; [
  #   setuptools
  #   wheel
  # ];

  installPhase = ''
    mkdir -p $out/bin
    cp myrientdl.py $out/bin/.myrientdl
    chmod +x $out/bin/.myrientdl
    makeWrapper $out/bin/.myrientdl $out/bin/${name} --prefix PYTHONPATH : .venv/${python3.sitePackages}
  '';
}
