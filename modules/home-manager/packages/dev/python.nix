{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    black
    isort
    pyright
    (python3.withPackages (ps: [
      ps.pygobject3
      ps.pillow
      ps.mypy
      ps.pytest
      ps.pytest-cov
      ps.ipykernel
      ps.ipython
      ps.ipywidgets
      ps.pandas
      ps.pyarrow
    ]))
  ];
}
