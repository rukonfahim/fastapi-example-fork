from __future__ import annotations

from fastapi import APIRouter

from app.core.config import get_settings
from app.models.schemas import Message

router = APIRouter()


@router.get("/healthz", response_model=Message, summary="Liveness probe")
async def healthz() -> Message:
    settings = get_settings()
    return Message(message=f"ok:{settings.version}:{settings.environment}")
