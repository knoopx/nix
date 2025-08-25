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
    # apostrophe
    # ascii-draw
    # authenticator
    # balatro
    # cartridges
    # commit
    # d-spy
    # decibels
    # delineate
    # dissent
    # eloquent
    # emblem
    # errands
    # exhibit # preview 3d models
    # fclones-gui
    # foliate
    # gapless
    # gnome-feeds
    # gnome-mahjongg
    # gnome-sudoku
    # google-chrome
    # impression
    # parlatype
    # pipeline
    # planify
    # pods
    # recordbox
    # rnote
    # showtime
    # sly
    # snapshot
    # varia
    # wike
    # wildcard
    llama-cpp
    gearlever
    lmstudio
    newsflash
    nfoview
    nicotine-plus
    picard
    prusa-slicer
    transmission_4-gtk
    vial
    pythonEnv
  ];
}
