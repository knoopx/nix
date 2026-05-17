{pkgs, ...}: {
  home.packages = [pkgs.voxtype-vulkan];

  xdg.configFile."voxtype/config.toml".text = ''
    state_file = "auto"
    engine = "parakeet"

    [hotkey]
    mode = "toggle"

    [audio]
    device = "default"
    sample_rate = 16000
    max_duration_secs = 60

    [parakeet]
    model = "parakeet-unified-en-0.6b"
    streaming = true

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
      After = ["niri.service"];
    };
    Service = {
      ExecStart = "${pkgs.voxtype-vulkan}/bin/voxtype";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
