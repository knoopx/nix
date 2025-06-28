{pkgs, ...}: let
  cudaTorch = pkgs.python313Packages.torch.override {
    cudaSupport = true;
  };

  accelerate = pkgs.python313Packages.accelerate.override {
    torch = cudaTorch;
  };

  peft = pkgs.python313Packages.peft.override {
    torch = cudaTorch;
    accelerate = accelerate;
  };

  python = pkgs.python313.withPackages (ps:
    with ps; [
      (bitsandbytes.override {torch = cudaTorch;})
      (diffusers.override {torch = cudaTorch;})
      (torchvision.override {torch = cudaTorch;})
      (transformers.override {torch = cudaTorch;})
      (xformers.override {torch = cudaTorch;}) #  nix build --max-jobs 1
      accelerate
      cudaTorch
      matplotlib
      peft
      pillow
      huggingface-hub
      matplotlib
      pillow
      pygobject3
      safetensors
      sentencepiece
      pygobject-stubs
      pygobject3
      requests
    ]);
in {
  home.packages = [python];
  # home.sessionVariables = {
  #   PYTHONPATH = "${python}/${pkgs.python313.sitePackages}";
  # };
  # systemd.user.sessionVariables = {
  #   PYTHONPATH = "${python}/${pkgs.python313.sitePackages}";
  # };
  programs = {
    vscode = {
      profiles.default = {
        userSettings = {
          "python.analysis.languageServerMode" = "full";
          "python.analysis.extraPaths" = [
            "${python}/${pkgs.python313.sitePackages}"
          ];
          "python.analysis.include" = [
            "${python}/${pkgs.python313.sitePackages}"
          ];
        };
      };
    };
  };

  # programs.fish.interactiveShellInit = ''
  #   set -gx PYTHONPATH "${python}/${pkgs.python313.sitePackages}"
  # '';
}
