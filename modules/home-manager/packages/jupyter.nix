{pkgs, ...}: {
  home.packages = with pkgs.python3Packages;
    [
      ipykernel          # IPython kernel for Jupyter notebooks
      ipython            # Interactive Python shell (enhanced REPL)
      ipywidgets         # Interactive widget library for Jupyter
      euporie            # Terminal-based Jupyter notebook viewer
    ]
    ++ [
      pkgs.nu-jupyter-kernel  # Nushell kernel for Jupyter notebooks
    ];

  xdg.dataFile."jupyter/kernels/nu/kernel.json" = {
    source = pkgs.writeText "kernel.json" ''
      {
        "argv": ["${pkgs.nu-jupyter-kernel}/bin/nu-jupyter-kernel", "start", "{connection_file}"],
        "display_name": "Nushell",
        "language": "nushell",
        "interrupt_mode": "message"
      }
    '';
  };
}
