{
  pkgs,
  lib,
}:
let
  py = pkgs.python314.pkgs;
  onnxruntime-gpu = py.buildPythonPackage rec {
    pname = "onnxruntime-gpu";
    version = "1.29.0";
    format = "wheel";

    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/37/4f/471818d239c55e86f11d1ce21dff6019db1b06b34c6993c5117fb4013dee/onnxruntime_gpu-1.29.0-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-XFDSRUG/YeZo3+Cno6Yt6Y3vgZWcgyzC03aBS2YcsAY=";
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