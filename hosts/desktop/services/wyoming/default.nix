{
  pkgs,
  config,
  ...
}: let
  # wakeWordsCollection = pkgs.fetchFromGitHub {
  #   owner = "fwartner";
  #   repo = "home-assistant-wakewords-collection";
  #   sha256 = "sha256-+Y3b5j1r2Y66u1n8P7v1h3g5Yk8KX9Oz5J6k3F0Y5P0=";
  # };
in {
  systemd.services.wyoming-satellite.path = with pkgs; [pipewire pulseaudio alsa-utils];
  services.wyoming = {
    satellite = {
      enable = true;
      user = "knoopx";
      group = "audio";
      uri = "tcp://0.0.0.0:10700";
      area = "living-room";
      microphone = {
        command = "pw-record --target 'alsa_input.usb-046d_081b_78B9CE90-02.mono-fallback' --rate 16000 --channels 1 --raw -";
        # command = "pw-record --target 'alsa_input.usb-046d_081b_78B9CE90-02.mono-fallback' --rate 16000 --channels 1 --format s16 -";
        # command = "pacat --record --device=alsa_input.usb-046d_081b_78B9CE90-02.mono-fallback --raw --format=s16le --channels=1 --rate=16000";
        autoGain = 5;
        noiseSuppression = 2;
      };
      sound = {
        # command = "pw-play -";
        # command = "aplay -r 22050 -c 1 -f S16_LE -t raw";
      };
      # sounds = {
      #   awake = "${./sounds/awake.wav}";
      #   done = "${./sounds/done.wav}";
      # };
      extraArgs = [
        "--debug"
        "--wake-uri=tcp://0.0.0.0:10400"
        "--wake-word-name=alexa"
        # https://github.com/fwartner/home-assistant-wakewords-collection/tree/main/en/computer
        # https://github.com/fwartner/home-assistant-wakewords-collection/tree/main/en/yo_bitch
        # https://github.com/fwartner/home-assistant-wakewords-collection/tree/main/en/home_assistant
      ];
    };
    openwakeword = {
      enable = true;
      uri = "tcp://0.0.0.0:10400";
      triggerLevel = 0;
      threshold = 0.1;
      extraArgs = [
        "--debug"
      ];
      # customModelsDirectories = ["/home/pungkula/models/yo_bitch.tflite"];
    };

    faster-whisper.servers."${config.networking.hostName}-whisper" = {
      enable = true;
      uri = "tcp://0.0.0.0:10300";
      device = "auto";
      language = "en";
      model = "turbo";
    };

    piper.servers."${config.networking.hostName}-piper" = {
      enable = true;
      uri = "tcp://0.0.0.0:10200";
      voice = "en-us-ryan-medium";
    };
  };

  networking.firewall.allowedTCPPorts = [10700 10400 10300 10200 10500];
}
