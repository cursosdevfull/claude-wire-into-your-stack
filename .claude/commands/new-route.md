---
description: Crea una nueva ruta (recurso) en la API, opcionalmente protegida con API key
argument-hint: <nombre-ruta> <proteger: true|false>
---

Crea un nuevo recurso en esta API Express.

- **Nombre de la ruta:** `$0`
- **¿Proteger con API key?:** `$1`

## 1. Valida los argumentos antes de cambiar nada

- `$0` es obligatorio. Normalízalo: quita la `/` inicial y pásalo a minúsculas. Solo puede tener letras minúsculas, números y guiones (`^[a-z][a-z0-9-]*$`). Si no cumple, detente y explica por qué.
- `$1` debe ser `true` o `false` (acepta también `sí`/`si`/`yes` como `true` y `no` como `false`). Si falta o no es válido, detente y pide al usuario que lo indique. **No** asumas un valor por defecto.
- Si ya existe `routes/<nombre>.js` o `server.js` ya monta `/<nombre>`, detente y avisa al usuario. No sobrescribas nada.
- No uses `health` ni `users`, porque ya existen.

En los pasos siguientes, `<nombre>` es el nombre normalizado, por ejemplo `products`. `<Nombre>` es la misma palabra con la primera letra en mayúscula, por ejemplo `Products`, y se usa en los nombres de las funciones. `<Singular>` es su forma en singular con mayúscula inicial, por ejemplo `Product` (para `roles` sería `Role`).

## 2. Capa de datos: `db/store.js`

Sigue la convención de `CLAUDE.md`: los datos solo se leen y escriben a través de `db/store.js`.

- Añade un array en memoria `<nombre>` (vacío). No añadas un contador de ids salvo que también crees una función para dar de alta registros; si no, ESLint lo marcará como variable sin usar.
- Añade las funciones `list<Nombre>()` y `get<Singular>ById(id)`, con el mismo estilo que `listUsers` y `getUser`.
- Dentro de `seed()`, reinicia el array a `[]`, para que `reset()` también lo limpie en los tests.
- Exporta las nuevas funciones en `module.exports`.

## 3. Router: `routes/<nombre>.js`

Copia la estructura de `routes/users.js` (CommonJS, `express.Router()`), con dos endpoints:

- `GET /`: devuelve `store.list<Nombre>()`.
- `GET /:id`: devuelve el registro, o `404` con `{ "error": "<Singular> not found" }` si no existe.

No añadas POST, PUT ni DELETE salvo que el usuario lo pida.

## 4. Monta la ruta en `server.js`

- Importa el router: `const <nombre>Router = require('./routes/<nombre>');`. Si el nombre lleva guiones, usa camelCase en la variable (por ejemplo, `order-items` → `orderItemsRouter`).
- Si `$1` es **true**: `app.use('/<nombre>', requireApiKey, <nombre>Router);`. El middleware está en `middleware/apiKey.js`. Si no existe, créalo siguiendo el skill `api-key-auth` (`.claude/skills/api-key-auth/`) y añade `middleware` al script `lint` de `package.json`.
- Si `$1` es **false**: `app.use('/<nombre>', <nombre>Router);`.

## 5. Tests: `tests/<nombre>.test.js`

Usa `node:test` + `supertest`, como en `tests/users.test.js`, con `store.reset()` en `beforeEach`. Incluye al menos:

- `GET /<nombre>` → `200` con un array.
- `GET /<nombre>/999` → `404` con `{ error: '<Singular> not found' }`.
- Si está protegida: añade `.set('x-api-key', 'test-key')` a los tests anteriores y un test más que compruebe que sin cabecera devuelve `401` con `{ error: 'API key is required' }`.

## 6. Documentación

En `docs/api.md`, añade una sección `## <Nombre>` con sus endpoints. Si está protegida, indica que requiere la cabecera `x-api-key`. Actualiza también la sección **Architecture** de `CLAUDE.md`, donde aparece la lista de archivos de `routes/`.

## 7. Verifica y resume

1. Ejecuta `npm test` y `npm run lint`. Ambos deben pasar. Si algo falla, corrígelo.
2. Resume al usuario, de forma breve:
   - los archivos creados y modificados,
   - si la ruta quedó protegida o no,
   - un ejemplo `curl` para probarla (con `-H "x-api-key: cualquiera"` si está protegida).
3. No hagas commit.
