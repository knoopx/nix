#!/usr/bin/env python3

import json
import subprocess
import sys
import os
import signal
import time
import tempfile
from pathlib import Path

# --- Configuration ---
# Use XDG_RUNTIME_DIR if available, otherwise fallback to /tmp
runtime_dir = Path(os.environ.get("XDG_RUNTIME_DIR", tempfile.gettempdir()))
STATE_FILE = runtime_dir / "niri_switcher_state.json"
STATE_FILE_TMP = runtime_dir / "niri_switcher_state.json.tmp" # For atomic writes
# --- End Configuration ---

# --- Global State ---
windows_data = {}  # Dictionary: {window_id: {title, app_id, ...}}
mru_order = []     # List of window_ids in MRU order (most recent first)
focused_window_id = None
focused_app_id = None
niri_process = None
# --- End Global State ---

def log(message):
    """Simple logger to stderr."""
    print(f"Daemon: {message}", file=sys.stderr)

def save_state():
    """Saves the current state (mru_order, focused_id, focused_app_id) to the state file atomically."""
    global mru_order, focused_window_id, focused_app_id, windows_data
    state = {
        "mru_order": mru_order,
        "focused_window_id": focused_window_id,
        "focused_app_id": focused_app_id,
        # Include windows_data in case the client needs app_id lookup
        "windows_data": windows_data
    }
    try:
        # Write to a temporary file first
        with open(STATE_FILE_TMP, 'w') as f:
            json.dump(state, f)
        # Atomically rename the temporary file to the final state file
        os.rename(STATE_FILE_TMP, STATE_FILE)
        # log(f"State saved: MRU={mru_order}, Focused={focused_window_id}, App={focused_app_id}")
    except Exception as e:
        log(f"Error saving state: {e}")

def update_focus(new_focused_id):
    """Updates the focused window ID, app ID, and MRU order."""
    global focused_window_id, focused_app_id, mru_order, windows_data

    # Prevent processing if focus didn't actually change to a valid window
    if new_focused_id == focused_window_id:
        return

    focused_window_id = new_focused_id
    if focused_window_id is not None and focused_window_id in windows_data:
        focused_app_id = windows_data[focused_window_id].get("app_id")
        # Move the newly focused window to the front of MRU
        if focused_window_id in mru_order:
            mru_order.remove(focused_window_id)
        mru_order.insert(0, focused_window_id)
        log(f"Focus changed to window {focused_window_id} (app: {focused_app_id}). MRU: {mru_order}")
    else:
        focused_app_id = None
        log(f"Focus lost or changed to unknown window ({focused_window_id}).")

    save_state()

def handle_windows_changed(event_data):
    """Processes the WindowsChanged event."""
    global windows_data, mru_order, focused_window_id, focused_app_id
    new_windows_dict = {win["id"]: win for win in event_data.get("windows", [])}
    new_window_ids = set(new_windows_dict.keys())
    current_window_ids = set(windows_data.keys())

    added_windows = new_window_ids - current_window_ids
    removed_windows = current_window_ids - new_window_ids

    # Update windows_data
    windows_data = new_windows_dict

    # Update MRU order
    # Remove closed windows
    mru_order = [win_id for win_id in mru_order if win_id not in removed_windows]
    # Add new windows to the front (or decide on a better strategy if needed)
    # For simplicity, let's add them right after the currently focused one if possible,
    # otherwise at the front. More complex heuristics could be used.
    # Let's just add them to the *end* for now, focus changes will bring them up.
    for win_id in added_windows:
        if win_id not in mru_order:
             mru_order.append(win_id) # Append new windows

    # Re-check focus, as the focused window might have changed properties
    current_focused_win = None
    for win_id, win_info in windows_data.items():
        if win_info.get("is_focused"):
            current_focused_win = win_id
            break

    # If the focused window changed *during* this update, process it
    if current_focused_win != focused_window_id:
         # Use update_focus which also saves state
         update_focus(current_focused_win)
    else:
        # Still save state if windows were added/removed but focus didn't change
         save_state()

    log(f"Windows changed. Total: {len(windows_data)}. Added: {added_windows}. Removed: {removed_windows}. MRU: {mru_order}")


def run_niri_listener():
    """Starts listening to niri events."""
    global niri_process
    command = ["niri", "msg", "--json", "event-stream"]
    log(f"Starting Niri listener: {' '.join(command)}")
    try:
        niri_process = subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1, # Line buffered
            errors='replace' # Handle potential decoding errors gracefully
        )

        # Read initial state (optional, could wait for first events)
        try:
            initial_windows_cmd = ["niri", "msg", "--json", "get-windows"]
            result = subprocess.run(initial_windows_cmd, capture_output=True, text=True, check=True)
            initial_data = json.loads(result.stdout)
            if "windows" in initial_data:
                 handle_windows_changed(initial_data) # Process initial window list
            initial_focus_cmd = ["niri", "msg", "--json", "get-active-window"]
            result = subprocess.run(initial_focus_cmd, capture_output=True, text=True, check=True)
            initial_focus_data = json.loads(result.stdout)
            if "active_window_id" in initial_focus_data:
                 update_focus(initial_focus_data["active_window_id"]) # Process initial focus

        except (subprocess.CalledProcessError, FileNotFoundError, json.JSONDecodeError) as e:
             log(f"Could not get initial Niri state: {e}")
             # Ensure state is saved even if initial fetch fails but daemon continues
             save_state()


        # Process event stream
        for line in iter(niri_process.stdout.readline, ''):
            if not line:
                break # Niri process ended
            try:
                event = json.loads(line)
                # Determine event type (first key in the dictionary)
                event_type = next(iter(event))
                event_data = event[event_type]

                if event_type == "WindowsChanged":
                    handle_windows_changed(event_data)
                elif event_type == "WindowFocusChanged":
                    new_focus = event_data.get("id")
                    update_focus(new_focus)
                elif event_type == "WorkspaceActiveWindowChanged":
                     # This also signifies a focus change relevant to MRU
                     new_focus = event_data.get("active_window_id")
                     update_focus(new_focus)
                # Add handlers for other events if needed (e.g., WorkspaceActivated)
                # else:
                #    log(f"Ignoring event: {event_type}")

            except json.JSONDecodeError:
                log(f"Ignoring invalid JSON: {line.strip()}")
            except Exception as e:
                log(f"Error processing event: {e} - Line: {line.strip()}")

    except FileNotFoundError:
        log(f"Error: 'niri' command not found. Is Niri running and in PATH?")
        sys.exit(1)
    except Exception as e:
        log(f"Error running Niri listener: {e}")
    finally:
        if niri_process and niri_process.poll() is None:
            log("Terminating Niri listener process...")
            niri_process.terminate()
            try:
                niri_process.wait(timeout=2)
            except subprocess.TimeoutExpired:
                niri_process.kill()
        log("Niri listener stopped.")
        # Clean up state file on exit? Optional.
        # try:
        #     if STATE_FILE.exists():
        #         os.remove(STATE_FILE)
        # except OSError as e:
        #     log(f"Could not remove state file {STATE_FILE}: {e}")


def signal_handler(sig, frame):
    """Handles termination signals."""
    log(f"Received signal {sig}, shutting down...")
    # No need to explicitly kill niri_process here, finally block in run_niri_listener handles it
    sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    # Ensure state file directory exists
    STATE_FILE.parent.mkdir(parents=True, exist_ok=True)

    # Initial empty state save, so client doesn't fail if no events received yet
    save_state()

    log("Niri Switcher Daemon started.")
    # Loop to allow restart if niri crashes/restarts?
    # For simplicity, just run once. Use systemd or similar for resilience.
    run_niri_listener()
    log("Niri Switcher Daemon finished.")