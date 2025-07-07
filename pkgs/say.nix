{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  pname = "say";
  version = "1.0.0";

  propagatedBuildInputs = [
    pkgs.curl
    pkgs.jq
    pkgs.mpv
  ];

  src = pkgs.writeScript "say" ''
    #!/usr/bin/env bash

    # Function to display help
    usage() {
        echo "Usage: $0 [-v voice] [-m model] [-i input_file] \"input_string\""
        exit 1
    }

    # Default values
    voice="af_heart"
    model="tts-1"
    input_file=""
    input_string=""

    # Parse command-line options
    while getopts 'v:m:i:h' flag; do
      case "''${flag}" in
        v) voice="''${OPTARG}" ;;
        m) model="''${OPTARG}" ;;
        i) input_file="''${OPTARG}" ;;
        h) usage ;;
        *) usage ;;
      esac
    done

    # Determine input_string: from file, stdin, or argument
    if [ -n "$input_file" ]; then
      if [ -f "$input_file" ]; then
        input_string=$(<"$input_file")
      else
        echo "Error: Input file does not exist"
        exit 1
      fi
    elif [ ! -t 0 ]; then
      # Read from stdin if available
      input_string="$(cat)"
    elif [ $OPTIND -le $# ]; then
      input_string="''${@:$OPTIND:1}"
    else
      echo "Error: Missing input string"
      usage
    fi

    # Prepare parameters for OpenAI API call
    PARAM=$(jq -n -c --arg model "$model" --arg voice "$voice" --arg input "$input_string" '$ARGS.named')

    curl -s "$OPENAI_API_BASE/audio/speech" \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -H "Content-Type: application/json" \
      -d "$PARAM" | mpv --no-terminal --force-window=no -
  '';

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/say
  '';
}
