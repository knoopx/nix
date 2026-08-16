{
  pkgs,
  lib,
}:
let
  py = pkgs.python314.pkgs;
  supertonicPy = py.buildPythonPackage rec {
    pname = "supertonic";
    version = "1.3.1";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/source/s/supertonic/supertonic-1.3.1.tar.gz";
      hash = "sha256-Q2fo9hr+phjayUj2vuVf7UchrWbKLT/JB3GipmdAcx4=";
    };
    format = "pyproject";
    nativeBuildInputs = [ py.setuptools py.wheel ];
    propagatedBuildInputs = with py; [ onnxruntime numpy huggingface-hub soundfile ];
    doCheck = false;
  };
  ttsPython = pkgs.python314.withPackages (ps: with ps; [
    supertonicPy
    numpy
    onnxruntime
    huggingface-hub
    soundfile
  ]);
in
pkgs.runCommand "tts" {
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  meta.mainProgram = "tts";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/tts \
    --add-flags ${./tts.nu} \
    --suffix PATH : ${ttsPython}/bin:${pkgs.pipewire}/bin:${pkgs.playerctl}/bin:${pkgs.coreutils}/bin:${pkgs.nushell}/bin \
    --set TTS_PY ${ttsPython.interpreter} \
    --set TTS_PY_SCRIPT ${./tts.py}
''