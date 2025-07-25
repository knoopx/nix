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
    ps.xformers
    ps.pysoundfile
  ]);
in {
  home.packages = with pkgs; [
    uv
    pythonEnv
  ];
}
