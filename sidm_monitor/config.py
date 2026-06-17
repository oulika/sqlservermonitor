from __future__ import annotations

import configparser
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class AppConfig:
    driver: str
    server: str
    database: str
    username: str
    password: str
    refresh_seconds: int = 10
    auto_unlock: bool = False
    unlock_after_seconds: int = 60
    log_dir: Path = Path("log")

    @property
    def connection_string(self) -> str:
        return (
            f"DRIVER={{{self.driver}}};"
            f"SERVER={self.server};"
            f"DATABASE={self.database};"
            f"UID={self.username};"
            f"PWD={self.password};"
            "TrustServerCertificate=yes"
        )


def load_config(path: str | Path = "config.ini") -> AppConfig:
    config_path = Path(path)
    parser = configparser.ConfigParser()
    parser.read(config_path, encoding="utf-8")

    return AppConfig(
        driver=parser.get("database", "driver", fallback="ODBC Driver 18 for SQL Server"),
        server=parser.get("database", "server", fallback="localhost"),
        database=parser.get("database", "database", fallback="master"),
        username=parser.get("database", "username", fallback="sa"),
        password=parser.get("database", "password", fallback=""),
        refresh_seconds=parser.getint("monitor", "refresh_seconds", fallback=10),
        auto_unlock=parser.getboolean("monitor", "auto_unlock", fallback=False),
        unlock_after_seconds=parser.getint("monitor", "unlock_after_seconds", fallback=60),
        log_dir=Path(parser.get("monitor", "log_dir", fallback="log")),
    )
