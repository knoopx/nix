{pkgs, ...}: {
  home.packages = with pkgs.python3Packages;
    [
      ipykernel
      ipython
      ipywidgets
      euporie
    ]
    ++ [
      pkgs.nu-jupyter-kernel
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
