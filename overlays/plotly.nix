final: prev: {
  python313Packages = prev.python313Packages.overrideScope (pfinal: pprev: {
    plotly = pprev.plotly.overrideAttrs {
      doCheck = false;
      doInstallCheck = false;
    };
  });
  python3Packages = prev.python3Packages.overrideScope (pfinal: pprev: {
    plotly = pprev.plotly.overrideAttrs {
      doCheck = false;
      doInstallCheck = false;
    };
  });
}
