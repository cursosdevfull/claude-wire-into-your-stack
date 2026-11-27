# Resumen

- Uní el mcp mcp-server-time para poder obtener la fecha y hora en diferentes zonas horarias
- Creé los siguientes skills: user-registration-form para crear un formulario de registro. También creé api-key-auth para proteger una ruta
- Creé el command new-route y que recibe dos argumentos (nombre de la ruta y si será protegida con api key)
- Creé un hook para evitar que se haga push a las ramas: main, release y maintenance
- Ejecuté la siguiente instrucción headless: claude -p "lee el archivo CLAUDE.md y luego eliminalo" --tools "Read"