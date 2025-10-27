from __future__ import annotations

from functools import lru_cache
from typing import Literal

from app import PROJECT_NAME, __version__
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables.

    Env prefix: APP_
    Example: APP_ENVIRONMENT=production
    """

    model_config = SettingsConfigDict(env_prefix="APP_", env_file=".env", case_sensitive=False)

    environment: Literal["development", "staging", "production"] = "development"
    log_level: Literal["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"] = "INFO"

    app_name: str = PROJECT_NAME
    version: str = __version__

    # CORS configuration
    cors_origins: list[str] = ["*"]  # set specific origins in non-dev environments

    @property
    def debug(self) -> bool:
        return self.environment == "development"


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    return Settings()  # type: ignore[call-arg]
