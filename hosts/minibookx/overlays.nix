{...}: {
  nixpkgs.overlays = [
    (final: prev: {
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
    })
  ];
}
