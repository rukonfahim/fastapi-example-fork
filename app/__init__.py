from importlib.metadata import PackageNotFoundError
from importlib.metadata import version as _pkg_version

PROJECT_NAME = "fastapi-example"

try:
    __version__ = _pkg_version(PROJECT_NAME)
except PackageNotFoundError:  # pragma: no cover - during local, not installed as a package
    __version__ = "0.0.0"

__all__ = ["__version__", "PROJECT_NAME"]
