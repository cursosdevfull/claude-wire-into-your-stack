---
name: user-registration-form
description: Genera la interfaz HTML estática (sin JavaScript) de un formulario de registro de usuario con los campos name, lastname, password y confirm password, con diseño minimalista en tonos verdes y fuente Verdana de 16px como máximo. Úsalo cuando el usuario pida crear, generar o regenerar el formulario de registro, la página de registro, el "signup form" o el "register form" de este repositorio.
---

# Formulario de registro de usuario

Crea una página HTML estática con un formulario de registro de usuario.

## Requisitos (obligatorios)

- **Campos**, en este orden y con estos `name`:
  1. `name`: input `type="text"`, requerido
  2. `lastname`: input `type="text"`, requerido
  3. `password`: input `type="password"`, requerido
  4. `confirm_password`: input `type="password"`, requerido
- Cada input lleva un `<label for="...">` asociado.
- Un botón `type="submit"` con el texto "Register".
- **Sin JavaScript**: nada de `<script>`, atributos `on*` ni `javascript:`. La validación es solo con atributos HTML (`required`).
- **Diseño minimalista**: una sola columna centrada, mucho espacio en blanco, sin sombras fuertes, sin imágenes ni iconos.
- **Colores**: solo tonos de verde (más blanco para el fondo de los inputs si hace falta). Usa la paleta de la plantilla.
- **Fuente**: `Verdana, sans-serif` en todo el documento. **Ningún** `font-size` mayor a `16px`.
- **No responsive**: ancho fijo, sin media queries ni unidades de viewport. No hace falta `<meta name="viewport">`.
- El CSS va inline en un `<style>` dentro de `<head>`. No uses dependencias externas (CDN, Google Fonts, etc.).

## Pasos

1. Copia la plantilla `template.html` (en la misma carpeta que este skill) como punto de partida.
2. Si el usuario no indica otra ruta, escribe el archivo en `public/register.html` en la raíz del repositorio.
3. Aplica solo los cambios que pida el usuario, sin romper los requisitos de arriba.
4. Antes de terminar, verifica:
   - `grep -nE "<script|[[:space:]]on[a-z]+=|javascript:" <archivo>` no devuelve nada.
   - Todos los `font-size` son de `16px` o menos.
   - No hay `@media`.
5. Indica al usuario la ruta del archivo y que puede abrirlo directamente en el navegador (por ejemplo, `open public/register.html` en macOS).

## Nota sobre la API

Este repositorio es una API Express (ver `CLAUDE.md`) y de momento no sirve archivos estáticos. **No** modifiques `server.js` ni las rutas a menos que el usuario lo pida explícitamente. El atributo `action` del formulario apunta a `/users` con `method="post"` solo como referencia.
