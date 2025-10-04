{pkgs, ...}: let
  pythonWithPackageOverrides = pkgs.python313.override {
    packageOverrides = self: super: {
      bitsandbytes = super.bitsandbytes.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [self.scikit-build-core];
      });
    };
  };
  pythonEnv = pythonWithPackageOverrides.withPackages (ps: [
    ps.accelerate
    ps.bitsandbytes
    ps.diffusers
    ps.huggingface-hub
    ps.matplotlib
    ps.peft
    ps.pillow
    ps.pygobject-stubs
    ps.pygobject3
    ps.requests
    ps.safetensors
    ps.sentencepiece
    ps.torchvision
    ps.transformers
    ps.openai
    ps.aiohttp
    ps.pydantic
    ps.uvicorn
    ps.fastapi
    ps.starlette
    ps.rich
    ps.xformers
    ps.triton
  ]);
in {
  home.packages = with pkgs; [
    # llama-cpp
    # lmstudio
    newsflash
    nfoview
    nicotine-plus
    picard
    prusa-slicer
    transmission_4-gtk
    vial
    # pythonEnv
    ollama-cuda
  ];
}
