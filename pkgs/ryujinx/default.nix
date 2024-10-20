{
  pkgs,
  libX11,
  libgdiplus,
  ffmpeg,
  openal,
  libsoundio,
  sndio,
  pulseaudio,
  vulkan-loader,
  glew,
  libGL,
  udev,
  SDL2,
  SDL2_mixer,
  ...
}: let
  pname = "ryujinx";
  version = "1.1";
  src = pkgs.fetchFromGitHub {
    owner = "ryujinx-mirror";
    repo = "ryujinx";
    rev = "r.b4cac89";
    hash = "sha256-THFwrXvsCm1u4/8C66Cs5zEUCHnDJCOVxMFYRof/lwA=";
  };
in (
  pkgs.buildDotnetModule {
    inherit pname version src;

    enableParallelBuilding = false;

    dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
    dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;

    doCheck = false;

    nugetDeps = ./deps.nix;
    runtimeDeps = [
      libX11
      libgdiplus
      SDL2_mixer
      openal
      libsoundio
      sndio
      pulseaudio
      vulkan-loader
      ffmpeg
      udev

      # Avalonia UI
      glew

      # Headless executable
      libGL
      SDL2
    ];

    projectFile = "Ryujinx.sln";

    executables = [
      "Ryujinx"
      # "Ryujinx.Gtk3"
    ];

    preFixup = ''
      mkdir -p $out/share/{applications,icons/hicolor/scalable/apps,mime/packages}
      pushd ${src}/distribution/linux

      install -D ./Ryujinx.desktop $out/share/applications/Ryujinx.desktop
      install -D ./mime/Ryujinx.xml $out/share/mime/packages/Ryujinx.xml
      install -D ../misc/Logo.svg $out/share/icons/hicolor/scalable/apps/Ryujinx.svg

      substituteInPlace $out/share/applications/Ryujinx.desktop \
        --replace "Ryujinx.sh %f" "$out/bin/Ryujinx %f"

      popd
    '';

    patches = [
      (pkgs.fetchurl {
        url = "https://github.com/knoopx/Ryujinx/commit/2816b4ce34da99050ef7cce5e710b5005b0dffb1.patch";
        sha256 = "sha256-W/XH1CkYJJXAppVKPdGTx6LbOJut7kbVUfv0RY899gU=";
      })
    ];
  }
)
