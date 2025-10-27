from fastapi import APIRouter

from app.models.schemas import Message

router = APIRouter()


@router.get("/", response_model=Message, summary="Root welcome")
async def root() -> Message:
    return Message(message="Hello World")


@router.get("/hello/{name}", response_model=Message, summary="Say hello")
async def say_hello(name: str) -> Message:
    return Message(message=f"Hello {name}")
