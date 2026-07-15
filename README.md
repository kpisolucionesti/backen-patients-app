# Emerboard API

API RESTful Rails 7.0 para gestión de emergencias hospitalarias.

## Endpoints principales

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/v1/auth/sign_in` | Login (username + password) |
| DELETE | `/api/v1/auth/sign_out` | Logout |
| GET | `/emergencies` | Lista paginada de emergencias |
| POST | `/emergencies` | Crear emergencia |
| GET | `/emergencies/:id` | Detalle con médicos y plan médico |
| POST | `/emergencies/:id/medical_plans` | Agregar indicación médica |
| GET | `/patients` | Lista de pacientes |
| GET | `/doctors` | Lista de médicos |
| GET | `/rooms` | Lista de salas |
| GET | `/users` | Lista de usuarios |
| GET | `/permissions` | Grupos de permisos disponibles |

## Modelos clave

- `Emergency` → `Patient`, `Doctor` (via `EmergencyDoctor`), `MedicalPlan`
- `User` → `Profile` (roles y permisos)
- `Patient`, `Doctor`, `Room`, `Note`, `MedicalPlan`

## Paginación

Los endpoints de listado aceptan:

| Parámetro | Default | Descripción |
|-----------|---------|-------------|
| `page` | 1 | Número de página |
| `per_page` | 50 | Registros por página |
| `q` | — | Búsqueda por nombre/CI/médico |
| `status` | — | Filtro por estado |
| `from` / `to` | — | Rango de fecha de ingreso |

Respuesta: `{ data: [...], total: N, page: N, per_page: N }`

## Migraciones

```bash
docker compose exec backend rails db:migrate
docker compose exec backend rails db:migrate:status
```

## Variables de entorno

Ver `.env.example` en la raíz del proyecto.

## Testing

```bash
docker compose exec backend rspec
docker compose exec backend bundle exec rubocop
docker compose exec backend bundle exec brakeman
```

Reporte de cobertura: `coverage/index.html`
