# NOTES

## 1. Servidor MCP
Conecté **fetch** (`uvx mcp-server-fetch`) en `.mcp.json`, a nivel de proyecto y sin credenciales. Le permite a Claude leer documentación externa (Express, supertest, ESLint) mientras trabaja en esta API.
La regla de `.claude/settings.json` en `permissions.allow` permite **solo** `mcp__fetch__fetch`, una herramienta de lectura. No da acceso libre a todo el servidor.
**Uso real:** con `claude -p "Usa la herramienta fetch para leer https://expressjs.com/en/guide/routing.html y resume cómo se usa express.Router()" --allowedTools "mcp__fetch__fetch"`, Claude leyó la guía y la relacionó con cómo `server.js` monta los routers de `routes/`.

## 2. Skill: `api-key-auth`
Captura cómo se protege una ruta con API key en este repo:
- un middleware en `middleware/apiKey.js`, montado antes del router;
- `401` con `{ "error": "API key is required" }`;
- tests con `node:test` + `supertest`, y `.set('x-api-key', ...)` en los tests de las rutas protegidas.

Incluye la plantilla `apiKey.js` en la carpeta del skill, así que funciona en un clon nuevo.
La descripción solo se activa cuando se pide **explícitamente** una API key o la cabecera `x-api-key`. Además, excluye JWT, sesiones, OAuth y login, para que no se dispare con cualquier pedido de "autenticación".
**Prueba:** pedí "Quiero exigir la cabecera x-api-key en la ruta /users" sin nombrar el skill. Claude abrió `.claude/skills/api-key-auth/SKILL.md` y siguió sus pasos.

## 3. Comando: `/new-route`
`/new-route <nombre> <true|false>` (recibe los argumentos con `$ARGUMENTS`) crea un recurso completo siguiendo las convenciones de `CLAUDE.md`:
- funciones en `db/store.js`;
- el router en `routes/`;
- el montaje en `server.js`, con `requireApiKey` opcional;
- los tests y la documentación.

Termina ejecutando `npm test` y `npm run lint`. Vale la pena porque crear un recurso toca siempre los mismos 5 o 6 archivos, y es fácil olvidar alguno.
**Prueba:** ejecuté `claude -p "/new-route products false"`. Creó `routes/products.js` y `tests/products.test.js`, modificó store, server, docs y `CLAUDE.md`, y los tests y el lint pasaron. Después descarté esos cambios porque este PR no cambia la app.

## 4. Hook: bloquear push a ramas protegidas
Es un hook **PreToolUse** (previene) con matcher **`Bash`**, registrado en `.claude/settings.json`. Ejecuta `.claude/hooks/block-protected-push.sh`, que sale con código 2 y bloquea cualquier `git push` hacia `main`, `release` o `maintenance` (también `--all` y `--mirror`).
**Prueba:** Claude intentó `git push --dry-run origin main` y el hook lo bloqueó con este mensaje: "Bloqueado por hook: no se permite hacer push a la rama protegida 'main'…".

## 5. Ejecución headless
```
claude -p "Ejecuta los tests del proyecto y resume el resultado en 2 líneas" --allowedTools "Bash(npm test)" "Read"
```
Solo permití `Bash(npm test)`, que ejecuta exactamente ese comando y ningún otro de Bash, y `Read`, para leer los tests si hace falta. No puede editar, borrar ni hacer push. Resultado: 5/5 tests pasaron.
