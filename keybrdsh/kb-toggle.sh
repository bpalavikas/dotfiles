#!/bin/bash
set -e

apply_custom() {
  setxkbmap -I"$HOME/.xkb" -layout bvrcolemak -variant basic -print \
  | xkbcomp -I"$HOME/.xkb" -w 0 - $DISPLAY
}

apply_qwerty() {
  setxkbmap us -print | xkbcomp -w 0 - $DISPLAY
}

# Detect custom by checking the loaded keymap
if xkbcomp -xkb "$DISPLAY" - 2>/dev/null | grep -q "bvrcolemak"; then
  apply_qwerty
  notify-send "Keyboard: QWERTY"
else
  apply_custom
  notify-send "Keyboard: bvrcolemak"
fi

