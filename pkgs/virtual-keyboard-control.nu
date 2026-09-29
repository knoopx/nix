#!/usr/bin/env nu

let program_name = if $env.PROGRAM_NAME? != null { $env.PROGRAM_NAME } else { "virtual-keyboard-control" }

# Global OSK enable/disable: start/stop the wvkbd user service. In --auto
# mode the keyboard already shows/hides on input focus by itself; this only
# turns the whole feature on (start) or off (stop), and shows a notification.
def notify [msg: string] {
  # notify-send (libnotify) talks to the mako daemon over the session bus;
  # point it at the bus socket explicitly (the service env has XDG_RUNTIME_DIR
  # but not always DBUS_SESSION_BUS_ADDRESS).
  $env.DBUS_SESSION_BUS_ADDRESS = $"unix:path=($env.XDG_RUNTIME_DIR)/bus"
  ^notify-send "Virtual keyboard" $msg
}

def is-enabled [] {
  # `lines | first` is required: systemctl exits 3 when inactive, and piping
  # the raw external output to `str trim` drops the value (empty) in that case.
  ^systemctl --user is-active wvkbd | lines | first | str starts-with "active"
}

def main [action: string] {
  match $action {
    "on" => {
      ^systemctl --user start wvkbd
      notify "Enabled"
    }
    "off" => {
      ^systemctl --user stop wvkbd
      notify "Disabled"
    }
    "toggle" => {
      if (is-enabled) {
        ^systemctl --user stop wvkbd
        notify "Disabled"
      } else {
        ^systemctl --user start wvkbd
        notify "Enabled"
      }
    }
    _ => {
      print $"Usage: ($program_name) on|off|toggle"
      exit 1
    }
  }
}
