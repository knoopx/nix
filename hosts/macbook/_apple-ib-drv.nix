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
    rev = "d8411ad1d87db8491e53887e36c3d37f445203eb";
    hash = "0s8bh3hw6kbl0s766pl7bg5ffsxra7iwjqlykhqrgwiwiripvz4q";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = ["pic" "format"];

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  installPhase = ''
    install -D *.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';
}
