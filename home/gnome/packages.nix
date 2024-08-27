{
  pkgs,
  defaults,
  inputs,
  ...
}: let
  gtk-apps = with pkgs; [
    amberol
    authenticator
    commit
    czkawka
    blender
    eog
    evince
    transmission_4-gtk
    fclones-gui
    file-roller
    # firefox
    gitg
    gnome-calendar
    nicotine-plus
    gnome-system-monitor
    gnome.gnome-control-center
    (google-chrome.override
      {
        commandLineArgs = [
          "--enable-features=VaapiVideoDecoder"
          "--enable-gpu-rasterization"
          "--enable-hardware-overlays"
          "--enable-oop-rasterization"
          "--enable-zero-copy"
          "--force-dark-mode"
          "--gtk-version=4"
          "--hide-crashed-bubble"
          "--hide-fullscreen-exit-ui"
          "--hide-sidepanel-button"
          "--hide-tab-close-buttons"
          "--ignore-gpu-blocklist"
          "--no-default-browser-check"
          "--password-store=gnome"
          "--remove-grab-handle"
          "--remove-tabsearch-button"
          "--remove-tabsearch-button"
          "--show-avatar-button=never"
        ];
      })
    mpv
    # alpaca
    nautilus
    zed-editor
    seahorse
    drawing
    xdg-desktop-portal-gnome

    # livecaptions
    # inputs.nix-software-center.packages.x86_64-linux.nix-software-center
    # (
    #   pkgsKiraNur.sudachi.overrideAttrs (oldAttrs: {
    #     src = fetchTarball {
    #       url = "https://git.nya.network/yuzu-emu/sudachi/archive/main.zip";
    #       sha256 = "sha256:17z4mz565hwxyhgiybilpngzysjjf5ijk0j0m7rg4qavj1g700xb";
    #     };
    #   })
    # )

    # (
    #   let
    #     version = "0.6.0";
    #   in
    #     buildGoModule {
    #       inherit version;
    #       pname = "semantic-grep";
    #       vendorHash = "sha256-HpKY5DkP9hRtH9O18irlNE2yd8eTSLogTpYTWR1kbXA=";

    #       src = fetchFromGitHub {
    #         owner = "arunsupe";
    #         repo = "semantic-grep";
    #         rev = "v${version}";
    #         hash = "sha256-uyPyj7Qk/iCqY/cRg3aJj9+gejDetHZCQtt/4QFxilg=";
    #       };

    #       meta = with lib; {
    #         homepage = "https://github.com/arunsupe/semantic-grep";
    #         description = "grep for words with similar meaning to the query";
    #       };
    #     }
    # )

    # (
    #   python311.pkgs.buildPythonApplication rec {
    #     pname = "codeqai";
    #     version = "0.0.18";

    #     pyproject = true;

    #     nativeBuildInputs = [
    #       python311Packages.poetry-core
    #     ];

    #     dependencies = with python311Packages; [
    #       inquirer
    #       langchain-openai
    #       langchain-community
    #       openai
    #       python-dotenv
    #       pyyaml
    #       rich
    #       streamlit
    #       tiktoken
    #       tree-sitter
    #       tree-sitter-languages
    #       yaspin
    #     ];

    #     # build-system = [
    #     #   # requires = ["poetry-core"]
    #     #   # build-backend = "poetry.core.masonry.api"
    #     # ];

    #     src = fetchPypi {
    #       inherit pname version;
    #       hash = "sha256-yLf/QVUHa7c41wIiT/Y6rTBrBCha4QeWWqTiF/bYMvA=";
    #     };

    #     # format = "other";

    #     # src = fetchurl {
    #     #   url = "https://github.com/fynnfluegge/codeqai/archive/refs/tags/${version}.tar.gz";
    #     #   sha256 = "sha256-AboKuipHX/OFx8vAv4wFw3d5Gq7zjMNklYhc3/Akmck=";
    #     # };
    #     # By default tests are executed, but they need to be invoked differently for this package
    #     # dontUseSetuptoolsCheck = true;
    #   }
    # )
  ];
in {
  home = {
    packages = gtk-apps ++ defaults.gnome.extensions;
  };
}
