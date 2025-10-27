# FastAPI Example (Best-Practices Edition)

This repository contains a minimal FastAPI application organized with a small, scalable structure and sensible defaults for configuration, logging, CORS, tests, and tooling.

## What’s included
- App factory with `lifespan` for init/shutdown hooks
- Environment-based settings via `pydantic-settings`
- Structured logging aligned with Uvicorn
- CORS middleware with environment-driven origins
- Health endpoint: `GET /healthz`
- Typed response models (Pydantic)
- Tests using `pytest` and `httpx` ASGI client
- Lint/format configuration using Ruff
- HTTP scratch file (`test_main.http`) for manual testing

## Project layout
```
app/
  api/
    endpoints/
      hello.py
      health.py
    __init__.py
    routes.py
  core/
    config.py
    logging.py
  models/
    schemas.py
  main.py
main.py                # re-exports app from app.main for uvicorn
pyproject.toml         # deps, tools, scripts
README.md
tests/
```

## Quickstart
You can use uv, pip, or your preferred tool.

### Using uv (recommended)
- Install uv: https://docs.astral.sh/uv/
- Create and sync the environment:
  ```bash
  uv sync --all-groups
  ```
- Run the app in development with auto-reload:
  ```bash
  uv run uvicorn app.main:app --reload
  ```
- Run tests:
  ```bash
  uv run pytest
  ```
- Lint/format (Ruff):
  ```bash
  uv run ruff check .
  uv run ruff format .
  ```

### Using pip
```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
# Install runtime + dev dependencies directly (project isn't a package install)
pip install fastapi uvicorn pydantic-settings pytest pytest-asyncio httpx ruff

uvicorn app.main:app --reload
pytest
```

## Configuration
Settings are provided by `app/core/config.py` using `pydantic-settings`.
Environment variables are prefixed with `APP_`.

- `APP_ENVIRONMENT` (development|staging|production) – defaults to `development`
- `APP_LOG_LEVEL` (DEBUG|INFO|WARNING|ERROR|CRITICAL) – defaults to `INFO`
- `APP_CORS_ORIGINS` – list of allowed origins; default `[*]`

Notes:
- Lists can be provided as comma-separated values or JSON, e.g.:
  - `APP_CORS_ORIGINS=http://localhost:3000,http://127.0.0.1:3000`
  - `APP_CORS_ORIGINS=["http://localhost:3000", "http://127.0.0.1:3000"]`

## Endpoints
- `GET /` → `{ "message": "Hello World" }`
- `GET /hello/{name}` → `{ "message": "Hello {name}" }`
- `GET /healthz` → `{ "message": "ok:{version}:{environment}" }`

## Development notes
- The app object is defined in `app/main.py` and re-exported in the root `main.py` for backward compatibility. You can run: `uvicorn app.main:app --reload` or `uvicorn main:app --reload`.
- Logging is configured during app startup in the FastAPI `lifespan` hook.
- Keep `APP_CORS_ORIGINS` restricted in non-development environments.

## Future improvements
- Add CI (e.g., GitHub Actions) to run tests and lint checks on PRs.
- Add type checking (mypy/pyright) and stricter rule sets when code grows.
- Add OpenAPI docs customization, security, and versioned API modules as needed.
