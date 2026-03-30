#!/usr/bin/env nu

def main [action: string] {
  match $action {
    "toggle" => {
      let status = ^voxtype status --format json | from json
      match $status.class {
        "recording" => {
          ^voxtype record stop
          ^recording-indicator stop
        }
        _ => {
          ^voxtype record start
          ^recording-indicator
        }
      }
    }
    _ => {
      print "Usage: voice-input-control toggle"
      exit 1
    }
  }
}
