{ pkgs, config, lib, ... }:
let
  enabled = config.defaults.development.python;
in
{
  environment.systemPackages = lib.mkIf enabled (with pkgs; [
    uv # Fast Python package installer and resolver
    black # Python code formatter
    isort # Python import sorter
    pyright # Type checker for Python
    (python314.withPackages (ps: [
      ps.pygobject3 # Python GObject introspection bindings
      ps.pillow # Python imaging library
      ps.mypy # Static type checker for Python
      ps.pytest # Python testing framework
      ps.pytest-cov # Coverage plugin for pytest
      ps.pandas # Python data analysis library
      ps.pyarrow # Apache Arrow Python library
    ]))
  ]);
}
