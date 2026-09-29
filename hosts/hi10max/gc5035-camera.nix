{ pkgs
, lib
, ...
}:

# Out-of-tree IPU6 camera-sensor modules for the CHUWI Hi10 Max front
# GC5035 camera (IPU6EP): the GC5035 sensor driver, the legacy IPU6 I2C
# bridge, and the patched int3472 discrete driver that maps the GCTI5035
# ACPI device's GPIOs to the sensor.
#
# Sources:
#   gc5035.c      from intel/ipu6-drivers (pinned)
#   int3472/*     from torvalds/linux v7.0, pinned to the EXACT Vor-Art
#                 sources.lock hashes (matches the 7.0 kernel the host boots)
#   ipu-bridge.c  from the CHUWI repo (Ubuntu noble kernel file, pinned)
#   Kbuild/Makefile + four CHUWI patches (pinned)
#   0006/0007     local mclk patches (hosts/hi10max/patches/ on disk;
#                 the on-disk files are the source of truth, tracked by
#                 the buildTree runCommand)
#
# Usage: import with the host's pkgs and pass the host kernel, e.g.
#   boot.extraModulePackages = [
#     ((import ./gc5035-camera.nix { inherit pkgs lib; }) (config.boot.kernelPackages))
#   ];

kernel:
let
  # Haumea scoped loader: everything comes from pkgs.
  fetchurl = pkgs.fetchurl;
  stdenv = pkgs.stdenv;

  # The GC5035 sensor driver (intel/ipu6-drivers, pinned).
  gc5035Src = fetchurl {
    url = "https://raw.githubusercontent.com/intel/ipu6-drivers/51fe72485032c779a261430a8100eaad5d8696b8/drivers/media/i2c/gc5035.c";
    sha256 = "d301d0204bbf6f16ee408250d3476d02215a2f90ea002405dda0e05e1b7799f3";
  };
  # Bundled in the CHUWI repo to avoid a Launchpad availability dependency;
  # byte-identical to the Ubuntu noble kernel file (pinned hash).
  ipuBridgeSrc = fetchurl {
    url = "https://raw.githubusercontent.com/Vor-Art/chuwi-hi10-max-linux/main/camera/kernel/vendor/ipu-bridge.c";
    sha256 = "16f32105a44b327b370051bb4d8ac21eda69d1171a4a6dc21823e98f7a3368a6";
  };
  kbuild = fetchurl {
    url = "https://raw.githubusercontent.com/Vor-Art/chuwi-hi10-max-linux/main/camera/kernel/Kbuild";
    sha256 = "f0fd61bd1a97e06b01431a6aff49b85355afe751a89b9efd1a65a3339ace652d";
  };
  makefile = fetchurl {
    url = "https://raw.githubusercontent.com/Vor-Art/chuwi-hi10-max-linux/main/camera/kernel/Makefile";
    sha256 = "e82062efa1a607ce9800e5723898af7fbd58ed6a5f8b4abc880af3673b225fbf";
  };
  patchAcpiDep = fetchurl {
    url = "https://raw.githubusercontent.com/Vor-Art/chuwi-hi10-max-linux/main/camera/kernel/patches/0001-gc5035-fix-acpi-dependency-evaluation.patch";
    sha256 = "36a31dfccf3db9ea2ecd21e15569454be019219f20c8bda0e72e04e69129377c";
  };
  patchInt3472Gpio = fetchurl {
    url = "https://raw.githubusercontent.com/Vor-Art/chuwi-hi10-max-linux/main/camera/kernel/patches/0002-int3472-map-gc5035-gpios-to-sensor.patch";
    sha256 = "2247c0d49b3f32cb24effea810a8ec0f98cba9f0c98f6511507185d73b9a2a28";
  };
  patchIpuBridge = fetchurl {
    url = "https://raw.githubusercontent.com/Vor-Art/chuwi-hi10-max-linux/main/camera/kernel/patches/0003-ipu-bridge-add-gc5035.patch";
    sha256 = "8893fa841c45a7e17208ebd08b11319db7196d5a86e5a3469644c8f4009e5442";
  };
  patchPowerSeq = fetchurl {
    url = "https://raw.githubusercontent.com/Vor-Art/chuwi-hi10-max-linux/main/camera/kernel/patches/0004-gc5035-stabilize-power-sequencing.patch";
    sha256 = "6a02f038412925d685e14b3267a1d2091190b26269815c8983362817e2deb3b5";
  };
  # int3472 driver files pinned to the EXACT Vor-Art sources.lock hashes
  # (torvalds/linux v7.0), matching the 7.0 kernel the host boots. Vor-Art
  # has no mclk patches: the sensor mclk comes from the int3472 clock _DSM
  # (patches 0002/0004) — but that rate is read from the firmware SSDB and
  # is wrong on this host, so the local 0006/0007 patches (see the on-disk
  # files under hosts/hi10max/patches/) acquire that clock as the sensor
  # mclk and force 24 MHz for the GC5035.
  discreteSrc = fetchurl {
    url = "https://raw.githubusercontent.com/torvalds/linux/v7.0/drivers/platform/x86/intel/int3472/discrete.c";
    sha256 = "1849fcdf700ce8c5a3404080d3baa21c48a373b5cb11d162cf0a806f90a186e4";
  };
  discreteQuirksSrc = fetchurl {
    url = "https://raw.githubusercontent.com/torvalds/linux/v7.0/drivers/platform/x86/intel/int3472/discrete_quirks.c";
    sha256 = "7dbcf534946cd836ddcfb0ecb780ab3666edf5caf0755cd59ae7d9eefe51fd6f";
  };
  clkAndRegulatorSrc = fetchurl {
    url = "https://raw.githubusercontent.com/torvalds/linux/v7.0/drivers/platform/x86/intel/int3472/clk_and_regulator.c";
    sha256 = "cd8314bc053982136205202a194c66b4dcffe9b8bdc21fbaee5b5afd34b3378f";
  };

  # 7.x kernel (7.2.8) LED API adaptation: the v7.0-pinned led.c (pled API)
  # does not compile against 7.2.8 (struct leds[] array +
  # skl_int3472_register_led/unregister_leds). It is replaced entirely by
  # the 7.2.8 in-tree led.c (byte-identical to the nixpkgs 7.2.8 kernel
  # tarball file, embedded below to avoid external availability), and the
  # two discrete.c call sites are adapted with the 0005 patch (con_id
  # "privacy" preserves the v7.0 privacy-LED behavior exactly: 7.2.8 names
  # the LED "%s::%s_led" with con_id).
  led728Src = pkgs.writeTextFile {
    name = "int3472-led-7.2.8.c";
    destination = "/led.c";
    text = ''
    // SPDX-License-Identifier: GPL-2.0
    /* Author: Hans de Goede <hdegoede@redhat.com> */

    #include <linux/acpi.h>
    #include <linux/gpio/consumer.h>
    #include <linux/leds.h>
    #include <linux/platform_data/x86/int3472.h>

    static int int3472_led_set(struct led_classdev *led_cdev, enum led_brightness brightness)
    {
    	struct int3472_led *led = container_of(led_cdev, struct int3472_led, classdev);

    	gpiod_set_value_cansleep(led->gpio, brightness);
    	return 0;
    }

    int skl_int3472_register_led(struct int3472_discrete_device *int3472, struct gpio_desc *gpio,
    			     const char *con_id)
    {
    	struct int3472_led *led;
    	char *p;
    	int ret;

    	if (int3472->n_leds >= INT3472_MAX_LEDS)
    		return -ENOSPC;

    	led = &int3472->leds[int3472->n_leds];
    	led->gpio = gpio;

    	/* Generate the name, replacing the ':' in the ACPI devname with '_' */
    	snprintf(led->name, sizeof(led->name),
    		 "%s::%s_led", acpi_dev_name(int3472->sensor), con_id);
    	p = strchr(led->name, ':');
    	if (p)
    		*p = '_';

    	led->classdev.name = led->name;
    	led->classdev.max_brightness = 1;
    	led->classdev.brightness_set_blocking = int3472_led_set;

    	ret = led_classdev_register(int3472->dev, &led->classdev);
    	if (ret)
    		return ret;

    	led->lookup.provider = led->name;
    	led->lookup.dev_id = int3472->sensor_name;
    	led->lookup.con_id = con_id;
    	led_add_lookup(&led->lookup);

    	int3472->n_leds++;
    	return 0;
    }

    void skl_int3472_unregister_leds(struct int3472_discrete_device *int3472)
    {
    	for (unsigned int i = 0; i < int3472->n_leds; i++) {
    		struct int3472_led *led = &int3472->leds[i];

    		led_remove_lookup(&led->lookup);
    		led_classdev_unregister(&led->classdev);
    		gpiod_put(led->gpio);
    	}
    }
    '';
  };
  patchLedApi728 = pkgs.writeTextFile {
    name = "0005-int3472-adapt-led-api-for-7-2.patch";
    destination = "/0005-int3472-adapt-led-api-for-7-2.patch";
    text = ''
    --- a/discrete.c
    +++ b/discrete.c
    @@ -385,7 +385,7 @@
    
     			break;
     		case INT3472_GPIO_TYPE_PRIVACY_LED:
    -			ret = skl_int3472_register_pled(int3472, gpio);
    +			ret = skl_int3472_register_led(int3472, gpio, "privacy");
     			if (ret)
    				err_msg = "Failed to register LED\n";

    @@ -460,7 +460,7 @@
     	gpiod_remove_lookup_table(&int3472->gpios);
    
     	skl_int3472_unregister_clock(int3472);
    -	skl_int3472_unregister_pled(int3472);
    +	skl_int3472_unregister_leds(int3472);
     	skl_int3472_unregister_regulator(int3472);
     }
     EXPORT_SYMBOL_NS_GPL(int3472_discrete_cleanup, "INTEL_INT3472_DISCRETE");
    '';
  };

  # Assemble the out-of-tree build tree. Every source is a pinned fetch, so
  # the tree is byte-identical to Vor-Art's sources.lock. runCommand adds
  # the interpolated files as build inputs automatically.
  buildTree = pkgs.runCommand "gc5035-camera-files" { } ''
    mkdir -p $out/patches
    # int3472 driver pinned to torvalds/linux v7.0 (the 7.0 kernel the
    # host boots), exact Vor-Art hashes
    cp ${discreteSrc} $out/discrete.c
    cp ${discreteQuirksSrc} $out/discrete_quirks.c
    cp ${clkAndRegulatorSrc} $out/clk_and_regulator.c
    # 7.x kernel (7.2.8) LED API: the v7.0 led.c (pled API) does not compile
    # against 7.2.8; the 7.2.8 in-tree led.c replaces it entirely (see the
    # embedded definitions above) and the 0005 patch adapts the discrete.c
    # call sites.
    cp ${led728Src}/led.c $out/led.c
    # the rest from pinned fetches
    cp ${gc5035Src} $out/gc5035.c
    cp ${ipuBridgeSrc} $out/ipu-bridge.c
    cp ${kbuild} $out/Kbuild
    cp ${makefile} $out/Makefile
    cp ${patchAcpiDep} $out/patches/0001-gc5035-fix-acpi-dependency-evaluation.patch
    cp ${patchInt3472Gpio} $out/patches/0002-int3472-map-gc5035-gpios-to-sensor.patch
    cp ${patchIpuBridge} $out/patches/0003-ipu-bridge-add-gc5035.patch
    cp ${patchPowerSeq} $out/patches/0004-gc5035-stabilize-power-sequencing.patch
    cp ${patchLedApi728}/0005-int3472-adapt-led-api-for-7-2.patch $out/patches/0005-int3472-adapt-led-api-for-7-2.patch
        # mclk acquisition (gc5035 probe grabs the int3472 per-sensor clock) and
    # the 24 MHz force for the GC5035 (SSDB reports the L1CK crystal rate): the
    # on-disk patches under hosts/hi10max/patches/ are the source of truth; the
    # local paths are auto-added as build inputs by the runCommand.
    cp ${./patches/0006-gc5035-acquire-int3472-mclk.patch} $out/patches/0006-gc5035-acquire-int3472-mclk.patch
    cp ${./patches/0007-int3472-force-24mhz-mclk-gc5035.patch} $out/patches/0007-int3472-force-24mhz-mclk-gc5035.patch
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gc5035-camera";
  version = kernel.kernel.modDirVersion;

  src = buildTree;

  nativeBuildInputs = kernel.kernel.moduleBuildDependencies;

  postPatch = ''
    patch -p1 -i patches/0001-gc5035-fix-acpi-dependency-evaluation.patch
    patch -p1 -i patches/0002-int3472-map-gc5035-gpios-to-sensor.patch
    patch -p1 -i patches/0003-ipu-bridge-add-gc5035.patch
    patch -p1 -i patches/0004-gc5035-stabilize-power-sequencing.patch
    patch -p1 -i patches/0005-int3472-adapt-led-api-for-7-2.patch
    patch -p1 -i patches/0006-gc5035-acquire-int3472-mclk.patch
    patch -p1 -i patches/0007-int3472-force-24mhz-mclk-gc5035.patch
  '';

  # The out-of-tree Makefile drives the kernel kbuild directly.
  buildPhase = ''
    runHook preBuild
    make -f Makefile \
      KERNELRELEASE=${kernel.kernel.modDirVersion} \
      KERNEL_BUILD=${kernel.kernel.dev}/lib/modules/${kernel.kernel.modDirVersion}/build \
      all
    runHook postBuild
  '';

  # Install into $out so boot.extraModulePackages merges it into the
  # booted kernel-modules tree. The modules install at the module root,
  # which depmod resolves before the in-tree subdirectory copies, so the
  # patched intel_skl_int3472_discrete shadows the in-tree one.
  installPhase = ''
    runHook preInstall
    make -C ${kernel.kernel.dev}/lib/modules/${kernel.kernel.modDirVersion}/build \
      M="$(pwd)" INSTALL_MOD_PATH="$out" modules_install
    runHook postInstall
  '';

  meta = {
    description = "Out-of-tree IPU6 GC5035 camera sensor modules (CHUWI Hi10 Max)";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
})
