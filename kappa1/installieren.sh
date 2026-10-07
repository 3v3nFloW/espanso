#!/bin/bash
# Tauscht /Applications/Espanso.app gegen den Kappa1-Fork (target/mac/Espanso.app).
# Sicherung des Originals: ~/Applications/Espanso-original-<version>.app — Rückweg: kappa1/zurueck.sh
set -euo pipefail
cd "$(dirname "$0")/.."
NEU=target/mac/Espanso.app
[ -x "$NEU/Contents/MacOS/espanso" ] || { echo "Fork nicht gebaut ($NEU fehlt)"; exit 1; }
ALT=/Applications/Espanso.app
version_alt=$( ("$ALT/Contents/MacOS/espanso" --version 2>/dev/null || true) | awk 'NR==1 {print $NF}')
version_alt=${version_alt:-unbekannt}
SICHERUNG="$HOME/Applications/Espanso-original-${version_alt}.app"

echo "1/4 espanso anhalten"
"$ALT/Contents/MacOS/espanso" stop 2>/dev/null || true
sleep 1

echo "2/4 Original sichern → $SICHERUNG"
mkdir -p "$HOME/Applications"
if [[ "$version_alt" != *kappa1* ]]; then
  [ -e "$SICHERUNG" ] || ditto "$ALT" "$SICHERUNG"
fi

echo "3/4 Fork einspielen ($("$NEU/Contents/MacOS/espanso" --version))"
rm -rf "$ALT"
ditto "$NEU" "$ALT"
xattr -cr "$ALT"

echo "4/4 starten"
"$ALT/Contents/MacOS/espanso" service register >/dev/null 2>&1 || true
"$ALT/Contents/MacOS/espanso" start || true
echo
echo "JETZT VON HAND: Systemeinstellungen › Datenschutz & Sicherheit › Bedienungshilfen:"
echo "  alten „Espanso“-Eintrag mit „–“ entfernen, dann den neuen einschalten (bzw. mit „+“ /Applications/Espanso.app hinzufügen)."
echo "Danach: espanso status  → „espanso is running“"
