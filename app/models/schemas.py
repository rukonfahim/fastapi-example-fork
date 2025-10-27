from __future__ import annotations

from pydantic import BaseModel, Field


class Message(BaseModel):
    message: str = Field(..., description="Human readable message")
