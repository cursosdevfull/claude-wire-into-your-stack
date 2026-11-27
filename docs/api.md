# API reference

Base URL: `http://localhost:3000`

All request and response bodies are JSON. Errors come back as `{ "error": "message" }`.

## Health

### GET /health
Returns the service status.

Response `200`:
```json
{ "status": "ok", "uptime": 12.34 }
```

## Users

All `/users` endpoints require an `x-api-key` header. Any non-empty value is accepted. Requests without it get `401`:
```json
{ "error": "API key is required" }
```

A user looks like:
```json
{ "id": 1, "name": "Ada Lovelace", "email": "ada@example.com" }
```

### GET /users
Returns an array of all users.

### GET /users/:id
Returns a single user, or `404` if no user has that id.

### POST /users
Creates a user. Body requires `name` and `email`; returns `201` with the created user, or `400` if either field is missing.

### PUT /users/:id
Updates an existing user. Body may include `name`, `email`, or both. Returns the updated user, `400` if neither field is given, or `404` if the user does not exist.

## Roles

All `/roles` endpoints require an `x-api-key` header (any non-empty value). Requests without it get `401`.

### GET /roles
Returns an array of all roles. Starts empty.

### GET /roles/:id
Returns a single role, or `404` with `{ "error": "Role not found" }` if no role has that id.
