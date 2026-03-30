#!/usr/bin/env nu

let pid_file = "/tmp/gpu-screen-recorder.pid"
let lock_file = "/tmp/gpu-screen-recorder.lock"

def main [--audio] {
  # Prevent double-trigger from hotkeys (press/release)
  let now_ts = (date now | format date "%s" | into int)
  if ($lock_file | path exists) {
    try {
      let last_ts = (open $lock_file | into int)
      if ($now_ts - $last_ts) < 1 {
        return
      }
    } catch {
      # Ignore malformed lock content and overwrite below
    }
  }
  $now_ts | save -f $lock_file

  # Ensure output directory exists
  mkdir $"($env.HOME)/Videos/Screen Recordings" | ignore

  # Check if gpu-screen-recorder is running using PID file
  if ($pid_file | path exists) {
    try {
      let info = (open $pid_file | from json)
      let pid = $info.pid | into int

      # Check if process with this PID is actually running
      if (^ps -p $pid --no-headers | length) > 0 {
        ^kill -TERM $pid
        rm -f $pid_file
        rm -f $lock_file

        ^recording-indicator stop
        ^notify-send "Screen Recording" "Stopped screen recording" --icon video-x-generic

        let output_file = $info.file
        if ($output_file | path exists) {
          ^dbus-send --session --dest=org.freedesktop.FileManager1 --type=method_call /org/freedesktop/FileManager1 org.freedesktop.FileManager1.ShowItems array:string:file://($output_file) string:""
        } else {
          ^xdg-open $"($env.HOME)/Videos/Screen Recordings"
        }
        return
      } else {
        rm -f $pid_file
      }
    } catch {
      rm -f $pid_file
    }
  }

  let timestamp = date now | format date "%Y-%m-%d-%H-%M-%S"
  let output_file = $"($env.HOME)/Videos/Screen Recordings/($timestamp).mkv"

  # Fire-and-forget; bash returns gpu-screen-recorder PID via $!
  let pid = if $audio {
    (^bash -lc 'gpu-screen-recorder -w screen -o "$1" -a default_output >/dev/null 2>&1 & echo $!' _ $output_file | str trim)
  } else {
    (^bash -lc 'gpu-screen-recorder -w screen -o "$1" >/dev/null 2>&1 & echo $!' _ $output_file | str trim)
  }

  {
    pid: $pid,
    file: $output_file
  } | to json | save -f $pid_file

  rm -f $lock_file
  ^recording-indicator
  ^notify-send "Screen Recording" "Started screen recording" --icon video-x-generic
}
