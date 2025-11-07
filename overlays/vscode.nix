final: prev: {
  vscode =
    prev.vscode.override
    {
      commandLineArgs = [
        "--disable-gpu"
      ];
    };
}
