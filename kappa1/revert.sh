#!/bin/bash
# Revert: put the original espanso from ~/Applications/Espanso-original-*.app back into /Applications.
set -euo pipefail
BACKUP=$(ls -d "$HOME"/Applications/Espanso-original-*.app 2>/dev/null | tail -1)
[ -n "$BACKUP" ] || { echo "no backup found"; exit 1; }
/Applications/Espanso.app/Contents/MacOS/espanso stop 2>/dev/null || true
sleep 1
rm -rf /Applications/Espanso.app
ditto "$BACKUP" /Applications/Espanso.app
tccutil reset Accessibility com.federicoterzi.espanso >/dev/null 2>&1 || true   # the fork's entry does not match the original
/Applications/Espanso.app/Contents/MacOS/espanso start || true
echo "Original restored: $(/Applications/Espanso.app/Contents/MacOS/espanso --version). Grant Accessibility again if asked."
echo "Note: the original ignores undo_backspace_presses — set undo_backspace back to false if a single Backspace should not revert."
