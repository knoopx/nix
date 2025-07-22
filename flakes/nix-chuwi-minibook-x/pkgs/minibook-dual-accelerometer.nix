{
  pkgs,
  lib,
  ...
}:
# This package provides the userspace tools and module source.
# The kernel module itself needs to be built separately with the correct kernel.
pkgs.stdenv.mkDerivation {
  pname = "minibook-dual-accelerometer";
  version = "unstable-2024-12-30";

  src = pkgs.fetchFromGitHub {
    owner = "rhalkyard";
    repo = "minibook-dual-accelerometer";
    rev = "2bd40f507dd97707ebaa93b88c6b662bf5e5b801";
    hash = "sha256-WMPgr8SimfVAJ5o1ePNW0Yp4TjDhbmlT9aTiAWSC8+Y=";
  };

  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.python3
  ];

  buildInputs = [
    pkgs.python3Packages.numpy
    pkgs.python3Packages.pyudev
    pkgs.kmod
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Install Python angle sensor service
    install -Dm755 angle-sensor-service/angle-sensor.py $out/bin/angle-sensor

    # Install tablet control script
    install -Dm755 angle-sensor-service/chuwi-tablet-control.sh $out/bin/chuwi-tablet-control

    # Install platform driver source (for kernel patches)
    mkdir -p $out/share/minibook-dual-accelerometer/platform-driver
    cp -r platform-driver/* $out/share/minibook-dual-accelerometer/platform-driver/

    # Install hack driver source (for building kernel module)
    mkdir -p $out/share/minibook-dual-accelerometer/hack-driver
    cp -r hack-driver/* $out/share/minibook-dual-accelerometer/hack-driver/

    # Wrap Python script with proper dependencies
    wrapProgram $out/bin/angle-sensor \
      --prefix PYTHONPATH : ${pkgs.python3Packages.numpy}/${pkgs.python3.sitePackages} \
      --prefix PYTHONPATH : ${pkgs.python3Packages.pyudev}/${pkgs.python3.sitePackages}

    runHook postInstall
  '';

  # Remove postInstall since we're not installing systemd files
  postInstall = "";

  meta = with lib; {
    description = "Scripts and drivers for Chuwi MiniBook X dual accelerometer support";
    longDescription = ''
      Essential scripts and kernel drivers for tablet-mode detection on the Chuwi MiniBook X.
      This package provides only the core components:

      - Python angle sensor service for accelerometer monitoring
      - Tablet control script for mode switching
      - DKMS source for hack driver (works with existing kernels)
      - Platform driver source (requires kernel patches)

      System integration (udev rules, systemd services) should be handled
      via NixOS modules.
    '';
    homepage = "https://github.com/rhalkyard/minibook-dual-accelerometer";
    license = licenses.gpl2Only;
    maintainers = [];
    platforms = platforms.linux;

    # This is specifically for Chuwi MiniBook X hardware
    badPlatforms = platforms.darwin ++ platforms.freebsd;
  };
}
