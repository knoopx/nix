#!/usr/bin/env python3

import json
import subprocess
import sys
import os
import signal
import tempfile
from pathlib import Path

runtime_dir = Path(os.environ.get("XDG_RUNTIME_DIR", tempfile.gettempdir()))
STATE_FILE = runtime_dir / "niri_switcher_state.json"

windows_data = {}
mru_order = []
focused_window_id = None
focused_app_id = None
niri_process = None

def save_state():
    global mru_order, focused_window_id, focused_app_id, windows_data
    state = {
        "mru_order": mru_order,
        "focused_window_id": focused_window_id,
        "focused_app_id": focused_app_id,
        "windows_data": windows_data
    }
    with open(STATE_FILE, 'w') as f:
        json.dump(state, f)

def update_focus(new_focused_id):
    global focused_window_id, focused_app_id, mru_order, windows_data

    if new_focused_id == focused_window_id:
        return

    focused_window_id = new_focused_id
    if focused_window_id is not None and focused_window_id in windows_data:
        focused_app_id = windows_data[focused_window_id].get("app_id")
        if focused_window_id in mru_order:
            mru_order.remove(focused_window_id)
        mru_order.insert(0, focused_window_id)
        print(f"Focus changed to window {focused_window_id} (app: {focused_app_id}). MRU: {mru_order}")
    else:
        focused_app_id = None
        print(f"Focus lost or changed to unknown window ({focused_window_id}).")

    save_state()

def handle_windows_changed(event_data):
    global windows_data, mru_order, focused_window_id, focused_app_id
    new_windows_dict = {win["id"]: win for win in event_data.get("windows", [])}
    new_window_ids = set(new_windows_dict.keys())
    current_window_ids = set(windows_data.keys())

    added_windows = new_window_ids - current_window_ids
    removed_windows = current_window_ids - new_window_ids

    windows_data = new_windows_dict

    mru_order = [win_id for win_id in mru_order if win_id not in removed_windows]
    for win_id in added_windows:
        if win_id not in mru_order:
             mru_order.append(win_id)

    current_focused_win = None
    for win_id, win_info in windows_data.items():
        if win_info.get("is_focused"):
            current_focused_win = win_id
            break

    if current_focused_win != focused_window_id:
         update_focus(current_focused_win)
    else:
         save_state()

    print(f"Windows changed. Total: {len(windows_data)}. Added: {added_windows}. Removed: {removed_windows}. MRU: {mru_order}")


def run_niri_listener():
    global niri_process
    command = ["niri", "msg", "--json", "event-stream"]
    print(f"Starting Niri listener: {' '.join(command)}")
    try:
        niri_process = subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1,
            errors='replace'
        )

        for line in iter(niri_process.stdout.readline, ''):
            if not line:
                break
            try:
                event = json.loads(line)
                event_type = next(iter(event))
                event_data = event[event_type]

                if event_type == "WindowsChanged":
                    handle_windows_changed(event_data)
                elif event_type == "WindowFocusChanged":
                    new_focus = event_data.get("id")
                    update_focus(new_focus)
                elif event_type == "WorkspaceActiveWindowChanged":
                     new_focus = event_data.get("active_window_id")
                     update_focus(new_focus)

            except json.JSONDecodeError:
                print(f"Ignoring invalid JSON: {line.strip()}")
            except Exception as e:
                print(f"Error processing event: {e} - Line: {line.strip()}")

    except FileNotFoundError:
        print(f"Error: 'niri' command not found. Is Niri running and in PATH?")
        sys.exit(1)
    except Exception as e:
        print(f"Error running Niri listener: {e}")
    finally:
        if niri_process and niri_process.poll() is None:
            print("Terminating Niri listener process...")
            niri_process.terminate()
            try:
                niri_process.wait(timeout=2)
            except subprocess.TimeoutExpired:
                niri_process.kill()
        print("Niri listener stopped.")


def signal_handler(sig, frame):
    print(f"Received signal {sig}, shutting down...")
    sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    STATE_FILE.parent.mkdir(parents=True, exist_ok=True)

    save_state()

    print("Niri Switcher Daemon started.")
    run_niri_listener()
    print("Niri Switcher Daemon finished.")