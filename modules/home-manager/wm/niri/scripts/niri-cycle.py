import subprocess
import os
import argparse
import json

STATE_FILE = os.path.expanduser("~/.cache/niri-cycle.json")


def focus_window_id(window_id):
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
        return False
    except Exception as e:
        print(f"An unexpected error occurred while focusing window {window_id}: {e}")
        return False


def load_state():
    try:
        with open(STATE_FILE, "r") as f:
            return json.load(f)
    except FileNotFoundError:
        return []
    except json.JSONDecodeError:
        print("Error decoding JSON from state file.")
        return []


def get_windows():
    try:
        result = subprocess.run(
            ["niri", "msg", "--json", "windows"],
            capture_output=True,
            text=True,
            check=True,
        )
        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error executing niri msg: {e}")
        return None
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        return None


def get_focused_window(windows):
    for window in windows:
        if window.get("is_focused"):
            return window
    return None


def main():
    parser = argparse.ArgumentParser(
        description="Cycle through Niri windows (Gnome Alt-Tab style)."
    )
    parser.add_argument(
        "--app",
        action="store_true",
        help="Cycle through windows of the currently focused application.",
    )
    parser.add_argument(
        "--workspace",
        action="store_true",
        help="Cycle through windows of the currently focused workspace.",
    )
    parser.add_argument(
        "--reverse", action="store_true", help="Cycle in reverse order."
    )

    args = parser.parse_args()

    mru_window_ids = load_state()
    if not mru_window_ids:
        return
    windows = get_windows()
    if not windows:
        return

    focused_window = get_focused_window(windows)
    if not focused_window:
        return

    app_id = focused_window["app_id"] if args.app else None
    workspace_id = focused_window["workspace_id"] if args.workspace else None

    step = -1 if args.reverse else 1
    filtered_windows = [
        id
        for id in windows
        if (not app_id or id["app_id"] == app_id)
        and (not workspace_id or id["workspace_id"] == workspace_id)
    ]
    filtered_windows = sorted(
        filtered_windows, key=lambda w: mru_window_ids.index(w["id"])
    )

    if not filtered_windows:
        return None

    current_index = next(
        (i for i, id in enumerate(mru_window_ids) if id == focused_window["id"]), -1
    )
    next_index = (current_index + step) % len(filtered_windows)
    next_window = filtered_windows[next_index]
    focus_window_id(next_window["id"])


if __name__ == "__main__":
    main()
