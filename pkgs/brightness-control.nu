#!/usr/bin/env nu

let program_name = if $env.PROGRAM_NAME? != null { $env.PROGRAM_NAME } else { "brightness-control" }

def main [action: string] {
  match $action {
    "up" => { brightnessctl set 5%+ }
    "down" => { brightnessctl set 5%- }
    _ => {
      print $"Usage: ($program_name) up|down"
      exit 1
    }
  }
  pw-play $env.SOUND_THEME_PATH/stereo/audio-volume-change.oga
}
