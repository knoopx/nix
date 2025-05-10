{
  pkgs,
  kernel,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "apple-ib-drv";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "t2linux";
    repo = "apple-ib-drv";
    rev = "4afd30950a7364b06b8cef8a34d6cc6653ca3120";
    hash = "sha256-ZoUfCWf9SuDAXItIywy5nfy8FsxIiCVwNDXQfDztolQ=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = ["pic" "format"];

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    # "INSTALL_MOD_PATH=$(out)"
  ];
  installPhase = ''
    install -D *.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';
}
