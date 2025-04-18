final: prev: {
  pegasus-frontend = prev.pegasus-frontend.overrideAttrs (origAttrs: {
    postInstall = ''
      echo "StartupWMClass=pegasus-frontend" >> $out/share/applications/org.pegasus_frontend.Pegasus.desktop
    '';
  });
}
