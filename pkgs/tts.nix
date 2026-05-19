{pkgs}: let
  py = pkgs.python313.pkgs;
  supertonicPy = py.buildPythonPackage rec {
    pname = "supertonic";
    version = "1.3.1";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/source/s/supertonic/supertonic-1.3.1.tar.gz";
      hash = "sha256-Q2fo9hr+phjayUj2vuVf7UchrWbKLT/JB3GipmdAcx4=";
    };
    format = "pyproject";
    nativeBuildInputs = [py.setuptools py.wheel];
    propagatedBuildInputs = with py; [onnxruntime numpy huggingface-hub soundfile];
    doCheck = false;
  };
  ttsPython = pkgs.python313.withPackages (_ps: [supertonicPy]);
in
  pkgs.writeShellApplication {
    name = "tts";
    runtimeInputs = [ttsPython pkgs.pipewire pkgs.playerctl];
    text = let
      python = ttsPython.interpreter;
      ttsPy = ./tts.py;
    in ''
      VOICE_STYLE="''${TTS_VOICE:-F4}"
      TOTAL_STEPS="''${TTS_STEPS:-5}"
      GAIN="''${TTS_GAIN:-3}"

      if [ -n "''${1:-}" ]; then
        TEXT="$1"
      else
        TEXT="$(cat)"
      fi

      # Kill any previously playing TTS
      if [ -f /tmp/tts.pid ]; then
        kill "$(cat /tmp/tts.pid)" 2>/dev/null || true
        rm -f /tmp/tts.pid
      fi

      # Pause all MPRIS players
      playerctl -a pause 2>/dev/null || true

      ${python} ${ttsPy} "''${VOICE_STYLE}" "$TEXT" "''${TOTAL_STEPS}" "''${GAIN}" | pw-play -a --rate=44100 --channels=1 - &
      PID=$!
      echo "$PID" > /tmp/tts.pid
      wait "$PID"
      playerctl -a play 2>/dev/null || true
      rm -f /tmp/tts.pid
    '';
  }
