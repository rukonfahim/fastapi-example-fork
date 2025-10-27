from __future__ import annotations

import logging
from logging.config import dictConfig


def configure_logging(level: str = "INFO") -> None:
    """Configure application logging with Uvicorn compatibility.

    This sets a concise, structured log format and aligns FastAPI/Uvicorn loggers.
    """

    dictConfig(
        {
            "version": 1,
            "disable_existing_loggers": False,
            "formatters": {
                "default": {
                    "()": "uvicorn.logging.DefaultFormatter",
                    "fmt": "%(levelprefix)s [%(name)s] %(message)s",
                    "use_colors": True,
                },
                "access": {
                    "()": "uvicorn.logging.AccessFormatter",
                    "fmt": '%(levelprefix)s %(client_addr)s - "%(request_line)s" %(status_code)s',
                },
            },
            "handlers": {
                "default": {
                    "formatter": "default",
                    "class": "logging.StreamHandler",
                    "stream": "ext://sys.stdout",
                },
                "access": {
                    "formatter": "access",
                    "class": "logging.StreamHandler",
                    "stream": "ext://sys.stdout",
                },
            },
            "loggers": {
                "uvicorn": {"handlers": ["default"], "level": level, "propagate": False},
                "uvicorn.error": {"level": level},
                "uvicorn.access": {"handlers": ["access"], "level": level, "propagate": False},
                # Your app namespace
                "app": {"handlers": ["default"], "level": level, "propagate": False},
            },
        }
    )

    # Also set root level to avoid noisy libraries
    logging.getLogger().setLevel(getattr(logging, level, logging.INFO))
