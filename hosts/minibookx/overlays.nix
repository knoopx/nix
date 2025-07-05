final: prev: {
  astal-shell = prev.astal-shell.overrideAttrs (old: {
    preInstall = ''
      substituteInPlace widgets/BottomBar/index.tsx \
        --replace-fail "const horizontalMargin = 300;" "const horizontalMargin = 200;" \
        --replace-fail "const verticalMargin = 100;" "const verticalMargin = 70;"

      substituteInPlace widgets/TopBar/index.tsx \
        --replace-fail "const horizontalMargin = 300" "const horizontalMargin = 200" \
        --replace-fail "const verticalMargin = 100" "const verticalMargin = 70"
    '';
  });

  grub2 = prev.grub2.overrideAttrs (oldAttrs: {
    # Disable unused variable warnings to fix compilation error
    NIX_CFLAGS_COMPILE = (oldAttrs.NIX_CFLAGS_COMPILE or "") + " -Wno-unused-variable";
  });
}
