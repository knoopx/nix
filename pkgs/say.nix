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
        echo "Usage: $0 [options] [\"input_string\"]"
        echo "Options:"
        echo "  -v voice              Voice name (default: af_heart)"
        echo "  -m model              Model name (default: tts-1)"
        echo "  -i input_file         Read input from file"
        echo "  -s speed              Speech speed (default: 1.15)"
        echo "  -u volume_multiplier  Volume multiplier (default: 4)"
        echo "  -l lang_code          Language code (default: empty)"
        echo "  -h                    Show this help message"
        exit 1
    }

    # Default values
    model="tts-1"
    voice="af_heart"
    input_file=""
    input_string=""
    speed=1.15
    volume_multiplier=4
    lang_code=""

    # Parse command-line options
    while getopts 'v:m:i:s:l:u:h' flag; do
      case "''${flag}" in
        m) model="''${OPTARG}" ;;
        v) voice="''${OPTARG}" ;;
        i) input_file="''${OPTARG}" ;;
        s) speed="''${OPTARG}" ;;
        l) lang_code="''${OPTARG}" ;;
        u) volume_multiplier="''${OPTARG}" ;;
        h) usage ;;
        *) usage ;;
      esac
    done

    # Shift past the processed options
    shift $((OPTIND-1))

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
    elif [ $# -gt 0 ]; then
      # Join all remaining arguments as the input string
      input_string="$*"
    else
      echo "Error: Missing input string"
      usage
    fi

    # Prepare parameters for OpenAI API call (kokoro)
    PARAM=$(jq -n -c \
      --arg model "$model" \
      --arg input "$input_string" \
      --arg voice "$voice" \
      --argjson speed "$speed" \
      --arg lang_code "$lang_code" \
      --argjson volume_multiplier "$volume_multiplier" \
      '$ARGS.named'
    )

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
