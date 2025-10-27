from fastapi import APIRouter

from app.api.endpoints import health, hello

api_router = APIRouter()

# Order matters for documentation grouping
api_router.include_router(hello.router, tags=["hello"])
api_router.include_router(health.router, tags=["health"])
