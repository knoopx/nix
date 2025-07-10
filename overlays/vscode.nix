final: prev: {
  vscode = prev.vscode.overrideAttrs (oldAttrs: rec {
    version = "1.102.0";
    src = prev.fetchurl {
      name = "vscode-linux-x64-${version}.tar.gz";
      url = "https://update.code.visualstudio.com/1.102.0/linux-x64/stable";
      sha256 = "sha256-zgrNohvsmhcRQmkX7Io2/U3qbVWdcqwT7VK7Y3ENb9g=";
    };
  });
}
