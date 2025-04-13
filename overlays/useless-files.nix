final: prev: {
  prev.nvidiaPackages.stable = prev.nvidiaPackages.stable.overrideAttrs (origAttrs: {
    postInstall = "rm $out/bin/nvidia-bug-report.sh";
  });
}
