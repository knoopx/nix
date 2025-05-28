#!/usr/bin/env python3

from dataclasses import dataclass, asdict
import json
import subprocess
import sys
import signal
import os
import threading
import time


@dataclass
class Window:
    id: int
    app_id: str
    workspace_id: int
    last_focused: float


@dataclass
class WindowState:
    cooldown = 256
    state_file = os.path.expanduser("~/.cache/niri-cycle.json")

    windows = {}
    timer = None

    def touch(self, id: int):
        if id in self.windows:
            self.windows[id].last_focused = time.time()

    def upsert(self, window_data: dict):
        window = Window(
            id=window_data["id"],
            app_id=window_data["app_id"],
            workspace_id=window_data["workspace_id"],
            last_focused=time.time(),
        )
        self.windows[window.id] = window
        self.save()

    def remove(self, id: int):
        if id in self.windows:
            del self.windows[id]
            self.save()

    # def save(self):
    #     if self.timer:
    #         self.timer.cancel()

    #     save_timer = threading.Timer(self.cooldown, self._save)
    #     save_timer.start()

    def save(self):
        with open(self.state_file, "w") as f:
            windows_sorted = sorted(
                self.windows.values(), key=lambda w: w.last_focused, reverse=True
            )
            state = [w.id for w in windows_sorted]
            json.dump(state, f)


@dataclass
class WindowTracker:
    state = WindowState()

    def handle_windows_changed(self, data):
        for window in data["windows"]:
            self.state.upsert(window)

    def handle_workspaces_changed(self, data):
        pass  # Currently not needed

    def handle_window_focus_changed(self, data):
        self.state.touch(data["id"])
        self.state.save()

    def handle_window_closed(self, data):
        self.state.remove(data["id"])

    def handle_window_opened_or_changed(self, data):
        self.state.upsert(data["window"])

    def handle_workspace_active_window_changed(self, data):
        self.state.touch(data["active_window_id"])
        self.state.save()

    def listener(self):
        try:
            niri_process = subprocess.Popen(
                ["niri", "msg", "--json", "event-stream"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                bufsize=1,
                errors="replace",
            )

            for line in iter(niri_process.stdout.readline, ""):
                if not line:
                    break
                try:
                    event = json.loads(line)
                    event_type = next(iter(event))
                    data = event[event_type]

                    if event_type == "WindowsChanged":
                        self.handle_windows_changed(data)
                    elif event_type == "WorkspacesChanged":
                        self.handle_workspaces_changed(data)
                    elif event_type == "WindowOpenedOrChanged":
                        self.handle_window_opened_or_changed(data)
                    elif event_type == "WindowClosed":
                        self.handle_window_closed(data)
                    elif event_type == "WindowFocusChanged":
                        self.handle_window_focus_changed(data)
                    elif event_type == "WorkspaceActiveWindowChanged":
                        self.handle_workspace_active_window_changed(data)

                except json.JSONDecodeError:
                    print(f"Ignoring invalid JSON: {line.strip()}")
                except Exception as e:
                    print(f"Error processing event: {e} - Line: {line.strip()}")

        except FileNotFoundError:
            print("Error: 'niri' command not found. Is Niri running and in PATH?")
            sys.exit(1)
        except Exception as e:
            print(f"Error running Niri listener: {e}")
        finally:
            if niri_process and niri_process.poll() is None:
                niri_process.terminate()
                try:
                    niri_process.wait(timeout=2)
                except subprocess.TimeoutExpired:
                    niri_process.kill()


def signal_handler(sig, _frame):
    print(f"Received signal {sig}, shutting down...")
    sys.exit(0)


if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    WindowTracker().listener()
