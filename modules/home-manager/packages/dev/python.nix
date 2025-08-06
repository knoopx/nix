{pkgs, ...}: let
  pythonWithPackageOverrides = pkgs.python313.override {
    packageOverrides = self: super: {};
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
    uv
    black
    isort
    pyright
    pythonEnv
  ];
}
