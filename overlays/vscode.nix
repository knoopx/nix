final: prev: {
  vscode =
    prev.vscode.override
    {
      commandLineArgs = [
        "--disable-features=WaylandFractionalScaleV1"
      ];
    };
}
