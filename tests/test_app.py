import re
from pathlib import Path

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


def test_nginx_proxy_target_matches_uvicorn_port():
    nginx_conf = Path(__file__).resolve().parents[1] / "nginx.conf"
    content = nginx_conf.read_text(encoding="utf-8")

    assert "proxy_pass http://127.0.0.1:8000;" in content
