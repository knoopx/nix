#!/usr/bin/env python3

import json
import subprocess
import sys
import os
import argparse
import tempfile
from pathlib import Path

# --- Configuration ---
# Use XDG_RUNTIME_DIR if available, otherwise fallback to /tmp
runtime_dir = Path(os.environ.get("XDG_RUNTIME_DIR", tempfile.gettempdir()))
STATE_FILE = runtime_dir / "niri_switcher_state.json"
# --- End Configuration ---

def log_error(message):
    """Logs an error message to stderr."""
    print(f"Cycle Error: {message}", file=sys.stderr)

def focus_window(window_id):
    """Uses niri msg to focus the specified window."""
    if window_id is None:
        log_error("Attempted to focus None window ID.")
        return False
    command = ["niri", "msg", "action", "focus-window", "--id", str(window_id)]
    try:
        # Use run instead of Popen as we just need to execute and finish
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        # print(f"Debug: Focused window {window_id}. Niri output: {result.stdout} {result.stderr}") # Optional debug
        return True
    except FileNotFoundError:
        log_error("'niri' command not found. Is Niri running and in PATH?")
        return False
    except subprocess.CalledProcessError as e:
        log_error(f"Failed to focus window {window_id}: {e}")
        log_error(f"Niri stderr: {e.stderr}")
        log_error(f"Niri stdout: {e.stdout}")
        return False
    except Exception as e:
        log_error(f"An unexpected error occurred while focusing window {window_id}: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(description="Cycle through Niri windows (Gnome Alt-Tab style).")
    parser.add_argument("--app", action="store_true", help="Cycle through windows of the currently focused application.")
    parser.add_argument("--reverse", action="store_true", help="Cycle in reverse order.")
    args = parser.parse_args()
    print(args)
    # --- Load State ---
    try:
        with open(STATE_FILE, 'r') as f:
            state = json.load(f)
        mru_order = state.get("mru_order", [])
        focused_window_id = state.get("focused_window_id")
        focused_app_id = state.get("focused_app_id")
        windows_data = state.get("windows_data", {}) # Load windows data for app_id lookup
    except FileNotFoundError:
        log_error(f"State file not found: {STATE_FILE}. Is the daemon running?")
        sys.exit(1)
    except json.JSONDecodeError:
        log_error(f"Invalid JSON in state file: {STATE_FILE}. Daemon might be restarting or file corrupted.")
        sys.exit(1)
    except Exception as e:
        log_error(f"Error loading state file {STATE_FILE}: {e}")
        sys.exit(1)

    # --- Determine Target Windows ---
    if not mru_order:
        # print("Debug: No windows in MRU list.") # Optional debug
        # No windows to cycle through
        sys.exit(0)

    target_list = mru_order # Default: cycle all windows

    if args.app:
        if focused_app_id and focused_window_id:
            # Filter MRU list to only include windows matching the focused app_id
            # Ensure the windows still exist according to the latest windows_data
            app_windows = [
                win_id for win_id in mru_order
                if str(win_id) in windows_data and windows_data[str(win_id)].get("app_id") == focused_app_id
            ]
            if app_windows:
                target_list = app_windows
            else:
                # Focused app has no other windows or app_id is missing, cycle all
                # print(f"Debug: No windows found for focused app_id: {focused_app_id}") # Optional debug
                target_list = mru_order # Fallback to cycling all
        else:
             # No focused app, cycle all
             # print("Debug: --app specified but no focused_app_id.") # Optional debug
             target_list = mru_order # Fallback to cycling all

    if not target_list:
         # print("Debug: Target list became empty.") # Optional debug
         sys.exit(0) # Nothing to cycle

    # --- Calculate Next/Previous Window ---
    try:
        current_index = target_list.index(focused_window_id)
    except ValueError:
        # Focused window not in the target list (e.g., filtered by --app, or just closed)
        # Default to the first item in the list as the 'current' effective position.
        current_index = 0 # Or maybe -1 if reversing? Let's stick with 0.

    list_len = len(target_list)
    if list_len <= 1:
        # Only one window (or none), nothing to cycle to
        # print("Debug: Only one or zero windows in target list.") # Optional debug
        sys.exit(0)

    if args.reverse:
        next_index = (current_index - 1 + list_len) % list_len
    else:
        next_index = (current_index + 1) % list_len

    next_window_id = target_list[next_index]

    # --- Focus the Window ---
    # print(f"Debug: Current={focused_window_id}, App={focused_app_id}, TargetList={target_list}, NextID={next_window_id}") # Optional debug
    focus_window(next_window_id)


if __name__ == "__main__":
    main()