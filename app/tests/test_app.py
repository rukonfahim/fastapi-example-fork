import re

import pytest
from app.main import app
from httpx import ASGITransport, AsyncClient


@pytest.mark.asyncio
async def test_root():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        resp = await ac.get("/")
    assert resp.status_code == 200
    assert resp.json() == {"message": "Hello World"}


@pytest.mark.asyncio
async def test_say_hello():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        resp = await ac.get("/hello/Yusuf")
    assert resp.status_code == 200
    assert resp.json() == {"message": "Hello Yusuf"}


@pytest.mark.asyncio
async def test_healthz():
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        resp = await ac.get("/healthz")
    assert resp.status_code == 200
    data = resp.json()
    assert "message" in data
    assert re.match(r"^ok:.*:(development|staging|production)$", data["message"]) is not None