#!/bin/sh

if hyprctl clients -j | grep -q '"class": "scratchpad"'; then
    hyprctl dispatch togglespecialworkspace scratchpad
else
    foot --app-id scratchpad
fi
