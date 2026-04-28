{ pkgs, ... }: {
  home.packages = with pkgs; [
    uv
    black
    isort
    pyright
    (python314.withPackages (ps: [
      ps.pygobject3
      ps.pillow
      ps.mypy
      ps.pytest
      ps.pytest-cov
      ps.pandas
      ps.pyarrow
    ]))
  ];
}
