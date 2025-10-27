from __future__ import annotations

from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app import PROJECT_NAME
from app.api.routes import api_router
from app.core.config import get_settings
from app.core.logging import configure_logging


@asynccontextmanager
async def lifespan(app: FastAPI):  # noqa: ARG001 - app is part of FastAPI contract
    settings = get_settings()
    configure_logging(settings.log_level)
    yield
    # place for graceful shutdown hooks (db, telemetry flush, etc.)


def create_app() -> FastAPI:
    settings = get_settings()

    application = FastAPI(
        title=settings.app_name or PROJECT_NAME,
        version=settings.version,
        debug=settings.debug,
        lifespan=lifespan,
    )

    # CORS
    application.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Routers
    application.include_router(api_router)

    return application


# Uvicorn discovery target
app = create_app()
