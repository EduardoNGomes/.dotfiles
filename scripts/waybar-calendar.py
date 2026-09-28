#!/usr/bin/env python3
"""Clock and compact, navigable calendar for Waybar."""

import calendar
import fcntl
import json
import os
import subprocess
import sys
from datetime import datetime
from html import escape
from pathlib import Path


STATE_FILE = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp")) / "waybar-calendar.json"
LOCK_FILE = STATE_FILE.with_suffix(".lock")
WEEKDAYS = ("Mo", "Tu", "We", "Th", "Fr", "Sa", "Su")
CELL_WIDTH = 4
WIDTH = len(WEEKDAYS) * CELL_WIDTH


def read_state():
    try:
        data = json.loads(STATE_FILE.read_text())
        return {"offset": int(data["offset"]), "alternate": bool(data["alternate"])}
    except (OSError, ValueError, KeyError, TypeError):
        return {"offset": 0, "alternate": False}


def save_state(state):
    temporary = STATE_FILE.with_suffix(f".{os.getpid()}.tmp")
    temporary.write_text(json.dumps(state))
    temporary.replace(STATE_FILE)


def render_calendar(now, offset):
    month_index = now.year * 12 + now.month - 1 + offset
    year, month_index = divmod(month_index, 12)
    month = month_index + 1
    title = escape(datetime(year, month, 1).strftime("%B %Y")).center(WIDTH).rstrip()

    lines = [
        f"<span foreground='#8fbcbb' weight='bold'>{title}</span>",
        "<span foreground='#81a1c1' weight='bold'>"
        + "".join(f"{day:^{CELL_WIDTH}}" for day in WEEKDAYS).rstrip()
        + "</span>",
    ]
    for week in calendar.Calendar(firstweekday=0).monthdayscalendar(year, month):
        cells = []
        for day in week:
            value = f"{day:^{CELL_WIDTH}}" if day else " " * CELL_WIDTH
            if day and (year, month, day) == (now.year, now.month, now.day):
                circled_day = chr(0x2460 + day - 1) if day <= 20 else chr(0x3251 + day - 21)
                value = f" <span foreground='#47e4ae' size='xx-large'>{circled_day}</span> "
            cells.append(value)
        lines.append("".join(cells).rstrip())

    return (
        "<span font_family='Hack Nerd Font Mono' size='large' line_height='1.2'>"
        + "\n".join(lines)
        + "</span>"
    )


def main():
    action = sys.argv[1] if len(sys.argv) > 1 else None
    if action not in (None, "--previous", "--next", "--reset", "--toggle-format"):
        raise SystemExit(f"Unknown action: {action}")

    if action is not None:
        with LOCK_FILE.open("a") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            state = read_state()
            if action == "--previous":
                state["offset"] -= 1
            elif action == "--next":
                state["offset"] += 1
            elif action == "--reset":
                state["offset"] = 0
            else:
                state["alternate"] = not state["alternate"]
            save_state(state)
        subprocess.run(("pkill", "-RTMIN+8", "-x", "waybar"), check=False)
        return

    state = read_state()
    now = datetime.now().astimezone()
    if state["alternate"]:
        label = " " + now.strftime("%d/%m/%Y")
    else:
        label = "󱑂 " + now.strftime("%H:%M %d/%b")
    print(json.dumps({"text": label, "tooltip": render_calendar(now, state["offset"])}, ensure_ascii=False))


if __name__ == "__main__":
    main()
