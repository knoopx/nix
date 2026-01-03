#!/usr/bin/env nu

let program_name = if $env.PROGRAM_NAME? != null { $env.PROGRAM_NAME } else { "volume-control" }

def main [action: string] {
  match $action {
    "up" => { wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ }
    "down" => { wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- }
    "mute" => { wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle }
    _ => {
      print $"Usage: ($program_name) up|down|mute"
      exit 1
    }
  }
  pw-play $env.SOUND_THEME_PATH/stereo/audio-volume-change.oga
}
