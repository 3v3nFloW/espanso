#!/bin/bash
# Rückweg: Original-Espanso aus ~/Applications/Espanso-original-*.app zurück nach /Applications.
set -euo pipefail
SICHERUNG=$(ls -d "$HOME"/Applications/Espanso-original-*.app 2>/dev/null | tail -1)
[ -n "$SICHERUNG" ] || { echo "keine Sicherung gefunden"; exit 1; }
/Applications/Espanso.app/Contents/MacOS/espanso stop 2>/dev/null || true
sleep 1
rm -rf /Applications/Espanso.app
ditto "$SICHERUNG" /Applications/Espanso.app
tccutil reset Accessibility com.federicoterzi.espanso >/dev/null 2>&1 || true   # Eintrag des Forks passt nicht zum Original
/Applications/Espanso.app/Contents/MacOS/espanso start || true
echo "Original zurück: $(/Applications/Espanso.app/Contents/MacOS/espanso --version). Bedienungshilfen ggf. neu erteilen."
echo "Hinweis: undo_backspace_presses in config/default.yml stört das Original nicht (wird ignoriert)."
