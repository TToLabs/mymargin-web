#!/usr/bin/env bash
# Publica una versión nueva: sube el .apk a los releases y reescribe version.json.
# Uso: tools/publicar.sh <ruta al .apk> "<notas cortas>" [obligatoria]
set -euo pipefail
APK="${1:?falta la ruta del .apk}"; NOTAS="${2:?faltan las notas}"; OBLIG="${3:-false}"
AAPT2="${AAPT2:-$(ls -d /c/Users/Alberto/AppData/Local/Android/Sdk/build-tools/*/ | tail -1)aapt2}"
cd "$(dirname "$0")/.."
INFO="$("$AAPT2" dump badging "$APK" | head -1)"
PKG=$(sed -n "s/.*name='\([^']*\)'.*/\1/p" <<<"$INFO")
CODE=$(sed -n "s/.*versionCode='\([0-9]*\)'.*/\1/p" <<<"$INFO")
NAME=$(sed -n "s/.*versionName='\([^']*\)'.*/\1/p" <<<"$INFO"); NAME="${NAME%-beta}"
[ "$PKG" = "cl.mymargineat.app.beta" ] || { echo "paquete inesperado: $PKG"; exit 1; }
ACTUAL=$(sed -n 's/.*"versionCode": *\([0-9]*\).*/\1/p' version.json)
[ "$CODE" -gt "$ACTUAL" ] || { echo "versionCode $CODE no supera al publicado ($ACTUAL)"; exit 1; }
cp "$APK" mymargin-beta.apk
gh release view "v$NAME" -R TToLabs/mymargin-web >/dev/null 2>&1 || \
  gh release create "v$NAME" mymargin-beta.apk -R TToLabs/mymargin-web --title "MyMargin $NAME" --notes "$NOTAS"
gh release upload latest mymargin-beta.apk --clobber -R TToLabs/mymargin-web
rm mymargin-beta.apk
cat > version.json <<JSON
{
  "versionCode": $CODE,
  "versionName": "$NAME",
  "apkUrl": "https://github.com/TToLabs/mymargin-web/releases/download/latest/mymargin-beta.apk",
  "notas": "$NOTAS",
  "obligatoria": $OBLIG
}
JSON
git add version.json && git commit -m "MyMargin $NAME (vc$CODE)" && git push
echo "publicado $NAME (vc$CODE)"
