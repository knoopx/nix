final: prev: {
  firefox = prev.writeShellScriptBin "firefox" ''
    firefox-esr "$@"
  '';
}
