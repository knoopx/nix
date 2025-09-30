final: prev: {
  kitty = prev.kitty.overrideAttrs {
    doCheck = false;
    doInstallCheck = false;
  };
}
