#!/usr/bin/env nu

# Recording indicator — launches a kitty panel overlay with a flashing red symbol.
# Usage: recording-indicator.nu [mic|webcam]

const self = path self

const symbols = {
  mic: "\u{f130}"
  webcam: "\u{f03d}"
}

def "main run" [
  symbol: string = "mic"
] {
  let sym = ($symbols | get -o $symbol | default "●")
  let on = $"(ansi red)($sym) REC(ansi reset)"
  let off = ""

  print -n $"\e[?25l"
  print -n $"\e[s"

  loop {
    for visible in [true false] {
      print -n $"\e[u\e[K"
      if $visible { print -n $on } else { print -n $off }
      sleep 1sec
    }
  }
}

def "main stop" [] {
  pkill -f $"panel.*recording-indicator"
}

def main [
  symbol: string = "mic"
] {
  try { main stop }
  let conf = (mktemp -t recording-indicator-kitty-XXXXXX.conf)
  $"background_opacity 0.0
dynamic_background_opacity yes
background #000000
hide_window_decorations yes
window_padding_width 0
window_margin_width 0
" | save -f $conf

  let cmd = $"kitten panel --edge=none --columns=7 --lines=1 --layer=overlay --margin-top 24 --margin-left 32 --config '($conf)' -o font_size=24 --detach nu '($self)' run ($symbol)"
  ^bash -c $cmd

  sleep 500ms
  rm -f $conf
}
