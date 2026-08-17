{ pkgs, ... }:
{
  home.packages = [
    pkgs.voxtype-vulkan # Voice-to-text with push-to-talk for Wayland
  ];

  xdg.dataFile."voxtype/models/ggml-large-v3.bin" = {
    source =
      pkgs.fetchurl {
        url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3.bin";
        hash = "sha256:1qnijhsv47x1vx2vixy4jr8n0k6q8ham9ggrqh1m53dr82s85lb4";
      }
    ;
  };

  xdg.configFile."voxtype/config.toml".text = ''
    state_file = "auto"
    engine = "whisper"

    [hotkey]
    mode = "toggle"

    [audio]
    device = "default"
    sample_rate = 16000
    max_duration_secs = 60

    [whisper]
    model = "large-v3"
    threads = 8

    [output]
    mode = "type"

    [output.notification]
    on_recording_start = false
    on_recording_stop = false
    on_transcription = false
  '';

  systemd.user.services.voxtype = {
    Unit = {
      Description = "Voxtype voice-to-text daemon";
      After = [ "niri.service" ];
    };
    Service = {
      ExecStart = "${pkgs.voxtype-vulkan}/bin/voxtype";
      Restart = "on-failure";
      RestartSec = 2;
    };
    # Install.WantedBy = [ "graphical-session.target" ];
  };
}
