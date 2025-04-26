{defaults, ...}: {
  environment = {
    variables = {
      EDITOR = defaults.editor;
    };
  };
}
