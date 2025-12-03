{...}: {
  services = {
    pipewire = {
      extraConfig.pipewire."99-convolver" = {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.name" = "convolver_sink";
              "node.description" = "convolver";
              "media.name" = "convolver";
              "filter.graph" = {
                nodes = [
                  {
                    type = "builtin";
                    label = "convolver";
                    name = "convFL";
                    config = {
                      filename = ./convolver.irs;
                      channel = 0;
                      gain = 4.0;
                    };
                  }
                  {
                    type = "builtin";
                    label = "convolver";
                    name = "convFR";
                    config = {
                      filename = ./convolver.irs;
                      channel = 1;
                      gain = 4.0;
                    };
                  }
                ];
                inputs = ["convFL:In" "convFR:In"];
                outputs = ["convFL:Out" "convFR:Out"];
              };
              "capture.props" = {
                "node.name" = "convolver_input";
                "media.class" = "Audio/Sink";
                "audio.channels" = 2;
                "audio.position" = ["FL" "FR"];
              };
              "playback.props" = {
                "node.target" = "alsa_output.usb-M-Audio_M-Track_2X2-00.analog-stereo";
              };
            };
          }
        ];
      };
    };
  };
}
