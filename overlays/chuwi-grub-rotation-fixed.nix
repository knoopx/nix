final: prev: {
  grub2 = prev.grub2.overrideAttrs (oldAttrs: {
    # Disable unused variable warnings to fix compilation error
    NIX_CFLAGS_COMPILE = (oldAttrs.NIX_CFLAGS_COMPILE or "") + " -Wno-unused-variable";
  });
}
