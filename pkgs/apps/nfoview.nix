{
  pkgs,
  fetchgit,
  nix-update-script,
  ...
}: let
  version = "2.0.1";

  pythonDeps = with pkgs.python3Packages; [
    pygobject3
    pygobject-stubs
  ];
in
  # pkgs.python3Packages.buildPythonApplication {
  #   inherit version;
  #   pname = "nfoview";
  #   propagatedBuildInputs = pythonDeps;
  #   build-system = [];
  #   src = fetchgit {
  #     url = "https://github.com/otsaloma/nfoview";
  #     rev = version;
  #     sha256 = "sha256-l7Aq/i5OS11wbuSDbRgpRyxPl5H+7v0Phn4utlF9BN4=";
  #   };
  # }
  pkgs.stdenv.mkDerivation {
    inherit version;
    pname = "nfoview";
    src = fetchgit {
      url = "https://github.com/otsaloma/nfoview";
      rev = version;
      sha256 = "sha256-l7Aq/i5OS11wbuSDbRgpRyxPl5H+7v0Phn4utlF9BN4=";
    };
    makeFlags = ["PREFIX=${placeholder "out"}"];

    # fonts-cascadia-code
    # gettext
    # gir1.2-gtk-4.0
    # python3
    # python3-dev
    # python3-gi

    nativeBuildInputs = with pkgs; [
      gettext
      # makeWrapper
      # copyDesktopItems
      # gobject-introspection
      # wrapGAppsHook
      #
      # (pkgs.python3.withPackages (pp:
      #   with pp; [
      #     pygobject3
      #   ]))
    ];
    # buildInputs = pythonDeps;
    # propagatedBuildInputs = pythonDeps;
    # pythonPath = with pkgs.python3Packages; [
    #   pygobject3
    # ];
    #     python3Packages.pygobject3
    # python3Packages.pygobject-stubs
    # python3Packages.wrapPython
    # propagatedBuildInputs = with pkgs.python3Packages; [pygobject3];
    # buildInputs = with pkgs; [
    #   cascadia-code
    #   gobject-introspection
    # ];

    passthru.updateScript = nix-update-script {};
  }
