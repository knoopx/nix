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
  version = "1.2.50";
  src = pkgs.fetchFromGitHub {
    owner = "GreemDev";
    repo = "ryujinx";
    rev = "1.2.50";
    hash = "sha256-t0qqshf2x+wogHtoxj9bthU03h29wvhrFCTUw8C2DDo=";
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
        url = "https://github.com/knoopx/Ryujinx/commit/fb68f94e652fa5edf7d12773f4af6550972b4cef.patch";
        sha256 = "sha256-2hjV+2fAsQXj1EpVB2hrxf+2e7JnOQb2Be0tMubrrVg=";
      })
    ];
  }
)
