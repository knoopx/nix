
import json
import subprocess
import sys
import os
import argparse
import tempfile
from pathlib import Path

runtime_dir = Path(os.environ.get("XDG_RUNTIME_DIR", tempfile.gettempdir()))
STATE_FILE = runtime_dir / "niri_switcher_state.json"

def focus_window(window_id):
    if window_id is None:
        return False
    command = ["niri", "msg", "action", "focus-window", "--id", str(window_id)]
    try:
        subprocess.run(command, check=True, capture_output=True, text=True)
        return True
    except FileNotFoundError:
        print("'niri' command not found. Is Niri running and in PATH?")
        return False
    except subprocess.CalledProcessError as e:
        print(f"Failed to focus window {window_id}: {e}")
        print(f"Niri stderr: {e.stderr}")
        print(f"Niri stdout: {e.stdout}")
        return False
    except Exception as e:
        print(f"An unexpected error occurred while focusing window {window_id}: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(description="Cycle through Niri windows (Gnome Alt-Tab style).")
    parser.add_argument("--app", action="store_true", help="Cycle through windows of the currently focused application.")
    parser.add_argument("--reverse", action="store_true", help="Cycle in reverse order.")
    args = parser.parse_args()

    try:
        with open(STATE_FILE, 'r') as f:
            state = json.load(f)
        mru_order = state.get("mru_order", [])
        focused_window_id = state.get("focused_window_id")
        focused_app_id = state.get("focused_app_id")
        windows_data = state.get("windows_data", {})
    except FileNotFoundError:
        print(f"State file not found: {STATE_FILE}. Is the daemon running?")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Invalid JSON in state file: {STATE_FILE}. Daemon might be restarting or file corrupted.")
        sys.exit(1)
    except Exception as e:
        print(f"Error loading state file {STATE_FILE}: {e}")
        sys.exit(1)

    if not mru_order:
        sys.exit(0)

    target_list = mru_order

    if args.app:
        if focused_app_id and focused_window_id:
            app_windows = [
                win_id for win_id in mru_order
                if str(win_id) in windows_data and windows_data[str(win_id)].get("app_id") == focused_app_id
            ]
            if app_windows:
                target_list = app_windows
            else:
                target_list = mru_order
        else:
             target_list = mru_order

    if not target_list:
         sys.exit(0)
    try:
        current_index = target_list.index(focused_window_id)
    except ValueError:
        current_index = 0
    list_len = len(target_list)
    if list_len <= 1:
        sys.exit(0)

    if args.reverse:
        next_index = (current_index - 1 + list_len) % list_len
    else:
        next_index = (current_index + 1) % list_len

    next_window_id = target_list[next_index]

    focus_window(next_window_id)


if __name__ == "__main__":
    main()