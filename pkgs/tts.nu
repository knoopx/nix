#!/usr/bin/env nu
# tts — synthesize and play a spoken message, pausing and resuming MPRIS players.
#
# Environment:
#   TTS_VOICE      voice style name (default "F4")
#   TTS_STEPS      synthesis steps  (default "5")
#   TTS_GAIN       amplitude gain   (default "3")
#   TTS_PY         python interpreter (set by the nix wrapper)
#   TTS_PY_SCRIPT  path to tts.py   (set by the nix wrapper)
#
# The message comes from the first positional argument, or from stdin when no
# argument is supplied.
#
# Only one TTS may play at a time: the playback pids are written to
# $XDG_RUNTIME_DIR/tts.pid; on the next invocation those pids are killed if
# still alive before the new playback starts.

let pidfile = ($env.XDG_RUNTIME_DIR? | default "/tmp") | path join "tts.pid"

def kill-previous [] {
  # Enforce single-instance: terminate the previous TTS if it is still playing.
  if ($pidfile | path exists) {
    for pid in ($pidfile | open --raw | lines | where $in != "" | into int) {
      if ((^kill -0 $pid | complete).exit_code == 0) {
        ^kill $pid err> /dev/null | ignore
      }
    }
    ^rm $pidfile err> /dev/null | ignore
  }
}

def playing-players [] {
  # Names of MPRIS players whose status is "Playing". Empty when there are none.
  let out = try {
    ^playerctl --all-players -f '{{playerName}} {{status}}' status err> /dev/null
  } catch {
    ""
  }
  $out
    | lines
    | where $in =~ "Playing$"
    | each { |l| $l | str trim | str replace " Playing" "" }
    | where $in != ""
}

def main [text?: string] {
  let message = if $text == null { ^cat | str trim } else { $text }

  let voice = $env.TTS_VOICE? | default "F4"
  let steps = $env.TTS_STEPS? | default "5"
  let gain = $env.TTS_GAIN? | default "3"

  kill-previous

  let resumed = playing-players
  ^playerctl --all-players pause err> /dev/null | ignore

  if ($message | is-empty) {
    print "tts: empty message; nothing to speak"
  } else {
    let id = (job spawn {
      ^$env.TTS_PY $env.TTS_PY_SCRIPT $voice $message $steps $gain
        | ^pw-play -a --rate=44100 --channels=1 -
    })
    # Record the playback pids so the next invocation can stop them, then block
    # until this playback finishes. Guarded: a very short playback may already
    # be gone by the time we read it, in which case there is nothing to record.
    sleep 40ms
    let pids = (try { job list | where id == $id | get pids.0 } catch { [] })
    if ($pids | length) > 0 {
      ($pids | into string | str join "\n") | save -f $pidfile
      while (job list | where id == $id | length) > 0 {
        sleep 80ms
      }
      ^rm $pidfile err> /dev/null | ignore
    }
  }

  for p in $resumed {
    ^playerctl -p $p play err> /dev/null | ignore
  }
}