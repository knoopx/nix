final: prev: let
  python = prev.python3;
  onnxruntime-gpu = python.pkgs.buildPythonPackage rec {
    pname = "onnxruntime-gpu";
    version = "1.30.0";
    format = "wheel";

    src = prev.fetchurl {
      url = "https://files.pythonhosted.org/packages/bb/75/09a6c97136c747608867a63114d988384e6ddb5507e08bbe9ced08744a4c/onnxruntime_gpu-1.30.0-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-WqzJjzlKE/SJHAoH5gR52PsLHqbzMotrOM/Ij537Beo=";
    };

    nativeBuildInputs = with prev; [
      autoPatchelfHook
    ];

    buildInputs = with prev.cudaPackages_13; [
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
      "libcuda.so.1"
    ];

    dependencies = with python.pkgs; [
      numpy
      flatbuffers
      protobuf
      sympy
    ];

    pythonImportsCheck = [ "onnxruntime" ];
  };
in {
  rclip = prev.rclip.overridePythonAttrs (old: {
    version = "3.2.4";
    doCheck = false;

    src = prev.fetchFromGitHub {
      owner = "knoopx";
      repo = "rclip";
      rev = "39eaa088";
      hash = "sha256-rcqattV+BWkkp7xNKIyGLhg1h3H4eBfu3+lPPrP86Tg=";
    };

    dependencies = old.dependencies ++ [
      onnxruntime-gpu
    ];
  });
}
