# MyMargin — descarga y actualizaciones

Repo **público** de distribución. El código de la app vive en `TToLabs/MyMargin` (privado);
acá solo se publica lo que un conductor necesita para instalarla y actualizarla.

- `index.html` — página pública: qué es, cómo instalar, botón de descarga.
- `version.json` — lo que la app consulta al abrir para mostrar el aviso de actualización.
- Release `latest` — el `.apk` (`mymargin-beta.apk`). El link no cambia entre versiones.

Web: https://ttolabs.github.io/mymargin-web/

## Publicar una versión nueva
1. Compilar y respaldar el APK como siempre (`apk/`).
2. `gh release upload latest mymargin-beta.apk --clobber -R TToLabs/mymargin-web`
3. Subir `versionCode` / `versionName` / `notas` en `version.json` y hacer push.
   El pop-up aparece en el teléfono solo cuando `versionCode` es mayor al instalado.

**Nunca** va acá: datos de viajes, capturas, credenciales ni nada de `jornadas/`.
