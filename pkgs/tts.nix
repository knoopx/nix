{ pkgs }:
let
  py = pkgs.python313.pkgs;
  supertonicPy = py.buildPythonPackage rec {
    pname = "supertonic";
    version = "1.3.1";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/source/s/supertonic/supertonic-1.3.1.tar.gz";
      hash = "sha256-Q2fo9hr+phjayUj2vuVf7UchrWbKLT/JB3GipmdAcx4=";
    };
    format = "pyproject";
    nativeBuildInputs = [ py.setuptools py.wheel ];
    propagatedBuildInputs = with py; [ onnxruntime numpy huggingface-hub soundfile ];
    doCheck = false;
  };
  ttsPython = pkgs.python313.withPackages (_ps: [ supertonicPy ]);
in
pkgs.writeShellApplication {
  name = "tts";
  runtimeInputs = [ ttsPython pkgs.pipewire ];
  text =
    let
      python = ttsPython.interpreter;
    in
    ''
                VOICE_STYLE="''${TTS_VOICE:-F4}"
                TOTAL_STEPS="''${TTS_STEPS:-5}"
                GAIN="''${TTS_GAIN:-4}"
                if [ -n "''${1:-}" ]; then
                  TEXT="$1"
                else
                  TEXT="$(cat)"
                fi
                ${python} -c "
      import sys
      import numpy as np
      from supertonic import TTS
      tts = TTS(auto_download=True)
      style = tts.get_voice_style(voice_name=sys.argv[1])
      text = sys.argv[2]
      wav, _ = tts.synthesize(text=text, voice_style=style, lang='en', total_steps=int(sys.argv[3]))
      amplified = wav.squeeze() * float(sys.argv[4])
      soft = np.tanh(amplified)
      samples = (soft * 32767).astype('int16')
      try:
        sys.stdout.buffer.write(samples.tobytes())
      except BrokenPipeError:
        pass
      " "''${VOICE_STYLE}" "$TEXT" "''${TOTAL_STEPS}" "''${GAIN}" | pw-play -a --rate=44100 --channels=1 -
    '';
}
