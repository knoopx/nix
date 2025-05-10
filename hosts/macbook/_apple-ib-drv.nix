{
  pkgs,
  kernel,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "apple-ib-drv";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "AdityaGarg8";
    repo = "apple-touchbar-drv";
    rev = "1ba449c88a02098373fe6ba01df8dd7b2658f9c9";
    hash = "sha256-ZoUfCWf9SuDAXItIywy5nfy8FsxIiCVwNDXQfDztolQ=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = ["pic" "format"];

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  # postPatch = ''
  #   substituteInPlace apple-ibridge.c --replace-fail '.owner		= THIS_MODULE,' ""
  # '';
  installPhase = ''
    install -D *.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';
}
