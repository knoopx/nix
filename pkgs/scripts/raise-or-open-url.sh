#!/bin/bash
set -euo pipefail

URL="$1"
if [ -z "$URL" ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

TAB_ID=$(bt list | awk -F'\t' -v url="$URL" '$3 == url {print $1}' | head -n 1)

if [ -n "$TAB_ID" ]; then
    bt activate "$TAB_ID"
    TAB_TITLE="$(bt list | awk -F'\t' -v url="$URL" '$3 == url {print $2}' | head -n 1) — Mozilla Firefox"
    ESCAPED_TITLE=$(printf '%s' "$TAB_TITLE" | sed 's/"/\\"/g')
    WIN_ID=$(niri msg --json windows | jq ".[] | select(.title == \"$ESCAPED_TITLE\") | .id" | head -n 1)

    if [ -n "$WIN_ID" ]; then
        niri msg action focus-window --id "$WIN_ID"
    fi
else
    # niri msg action spawn -- firefox --profile ~/.mozilla/firefox/kiosk/ --new-window "$URL"
    niri msg action spawn -- firefox --new-window "$URL"
fi