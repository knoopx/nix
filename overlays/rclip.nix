final: prev: let
  python = prev.python3;
  onnxruntime-gpu = python.pkgs.buildPythonPackage rec {
    pname = "onnxruntime-gpu";
    version = "1.24.4";
    format = "wheel";

    src = prev.fetchurl {
      url = "https://files.pythonhosted.org/packages/3e/5b/82b27f766b64f97c9a98b772dc07b608e900bd2faafdfa176b86d20be7f8/onnxruntime_gpu-1.24.4-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
      hash = "sha256-r53X75LZTHXlUjzwcOGA89jNuy/AB9zql7pxsD47ltY=";
    };

    nativeBuildInputs = with prev; [
      autoPatchelfHook
    ];

    buildInputs = with prev.cudaPackages; [
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
