#!/usr/bin/env nu
let line = (zbarcam -1 --quiet | complete | get stdout | str trim)

if $line == "" {
  print "Error: No QR code detected."
  exit 1
}

let uri = ($line | str replace --regex "^QR-Code:" "")

if not ($uri | str starts-with "otpauth-migration://") {
  print "Error: Detected QR code does not appear to be an otpauth-migration URI."
  exit 1
}

otpauth -link $uri
