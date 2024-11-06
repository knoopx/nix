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
  nix-update-script,
  ...
}: let
  pname = "ryujinx";
  version = "r.49574a9";
  src = pkgs.fetchFromGitHub {
    owner = "ryujinx-mirror";
    repo = "ryujinx";
    rev = version;
    hash = "sha256-UALAWXc4d1dD/ZFuIIxq9YBreSMc5BIpWf0Bhq7pheM=";
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

    projectFile = "src/Ryujinx/Ryujinx.csproj";

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

      substituteInPlace $out/share/applications/Ryujinx.desktop  --replace-fail "Ryujinx.sh %f" "$out/bin/Ryujinx %f"

      popd
    '';

    patches = [
      (pkgs.fetchurl {
        url = "https://github.com/knoopx/Ryujinx/commit/2816b4ce34da99050ef7cce5e710b5005b0dffb1.patch";
        sha256 = "sha256-W/XH1CkYJJXAppVKPdGTx6LbOJut7kbVUfv0RY899gU=";
      })
      (pkgs.fetchurl {
        url = "https://github.com/Ryujinx-NX/Ryujinx/commit/6ecfd2fd12f25cd7b9b976484cd030eaad68f28d.patch";
        sha256 = "sha256-BnIEpzlFd6zuoZ0a7PiCdfJN4PFr6ih8w4you2o6nLg=";
      })
      (pkgs.fetchurl {
        url = "https://github.com/Vudjun/Ryujinx/commit/c4ee9c7555a7b89665a4eb5b938359bd73de5794.patch";
        sha256 = "sha256-icLuWGSSwodosjRocIdzofwcASxx73oO13Fr1aRTP7U=";
      })
      (pkgs.fetchurl {
        url = "https://github.com/Vudjun/Ryujinx/commit/80fa93faefa6184d3a15bd36407c600a145919a9.patch";
        sha256 = "sha256-9JHHrxd6oGNq8hNXl7UxP73LJbUVNXCNOiVpvaV2sd8=";
      })
    ];

    passthru.updateScript = nix-update-script {};
  }
)
