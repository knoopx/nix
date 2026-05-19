{pkgs}: let
  pname = "niri-notify-focus";
  version = "0.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "Oaklight";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-POaBIo5k4ukVTuDxaVqnc2Z+D1wk0DB6ny6U1CbaCB4=";
  };

  dbus-python = pkgs.python3.pkgs."dbus-python";
  pygobject3 = pkgs.python3.pkgs.pygobject3;
in
  pkgs.stdenv.mkDerivation {
    inherit pname version src;

    dontBuild = true;

    nativeBuildInputs = [pkgs.makeWrapper];

    installPhase = ''
      mkdir -p $out/bin $out/lib/systemd/user $out/share/doc/${pname}

      # Copy script and replace shebang to use the correct python
      sed 's|#!/usr/bin/env python3|#!${pkgs.python3}/bin/python3|' \
        niri-notify-focus > $out/bin/${pname}
      chmod 755 $out/bin/${pname}

      # Wrap with PYTHONPATH so dbus and gi modules are found
      wrapProgram $out/bin/${pname} \
        --prefix PYTHONPATH : "${dbus-python}/${pkgs.python3.sitePackages}:${pygobject3}/${pkgs.python3.sitePackages}"

      substituteInPlace niri-notify-focus.service \
        --replace-fail "/usr/bin/niri-notify-focus" "$out/bin/${pname}"
      install -Dm644 niri-notify-focus.service $out/lib/systemd/user/${pname}.service
      install -Dm644 config.toml.example $out/share/doc/${pname}/config.toml.example
    '';

    meta = {
      description = "Focus source window on notification click for the niri Wayland compositor";
      homepage = "https://github.com/Oaklight/niri-notify-focus";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
      mainProgram = pname;
    };
  }
