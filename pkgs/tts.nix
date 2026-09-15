{
  pkgs,
  lib,
}:
let
  py = pkgs.python314.pkgs;
  onnxruntime-gpu = py.buildPythonPackage rec {
    pname = "onnxruntime-gpu";
    version = "1.30.0";
    format = "wheel";

    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/bb/75/09a6c97136c747608867a63114d988384e6ddb5507e08bbe9ced08744a4c/onnxruntime_gpu-1.30.0-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-WqzJjzlKE/SJHAoH5gR52PsLHqbzMotrOM/Ij537Beo=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    buildInputs = with pkgs.cudaPackages; [
      cuda_cudart
      libcublas
      libcusparse
      libcufft
      libcurand
      cudnn
    ];

    autoPatchelfIgnoreMissingDeps = [
      "libnvinfer.so.10"
      "libnvonnxparser.so.10"
      "libcublas.so.13"
      "libcublasLt.so.13"
      "libcudart.so.13"
      "libcuda.so.1"
    ];

    dependencies = with py; [
      numpy
      flatbuffers
      protobuf
      sympy
    ];

    pythonImportsCheck = [ "onnxruntime" ];
  };
  supertonicPy = py.buildPythonPackage rec {
    pname = "supertonic";
    version = "1.3.1";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/source/s/supertonic/supertonic-1.3.1.tar.gz";
      hash = "sha256-Q2fo9hr+phjayUj2vuVf7UchrWbKLT/JB3GipmdAcx4=";
    };
    format = "pyproject";
    nativeBuildInputs = [ py.setuptools py.wheel ];
    propagatedBuildInputs = with py; [ onnxruntime-gpu numpy huggingface-hub soundfile ];
    dontCheckRuntimeDeps = true;
    doCheck = false;
  };
  ttsPython = pkgs.python314.withPackages (ps: with ps; [
    supertonicPy
    numpy
    onnxruntime-gpu
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