from pathlib import Path

from sidm_monitor.config import AppConfig, load_config


def test_config_defaults() -> None:
    config = AppConfig(
        driver="ODBC Driver 18 for SQL Server",
        server="localhost",
        database="master",
        username="sa",
        password="secret",
    )

    assert config.refresh_seconds == 10
    assert config.auto_unlock is False
    assert config.unlock_after_seconds == 60
    assert config.log_dir == Path("log")


def test_load_config_reads_database_and_monitor_options(tmp_path: Path) -> None:
    config_path = tmp_path / "config.ini"
    config_path.write_text(
        "\n".join(
            [
                "[database]",
                "driver = SQL Server Native Client 11.0",
                "server = pfsvr0",
                "database = bstest",
                "username = sa",
                "password = t2b0v5",
                "",
                "[monitor]",
                "refresh_seconds = 15",
                "auto_unlock = yes",
                "unlock_after_seconds = 90",
                "log_dir = logs",
            ]
        ),
        encoding="utf-8",
    )

    config = load_config(config_path)

    assert config.driver == "SQL Server Native Client 11.0"
    assert config.server == "pfsvr0"
    assert config.database == "bstest"
    assert config.username == "sa"
    assert config.password == "t2b0v5"
    assert config.refresh_seconds == 15
    assert config.auto_unlock is True
    assert config.unlock_after_seconds == 90
    assert config.log_dir == Path("logs")


def test_connection_string_escapes_driver_with_braces() -> None:
    config = AppConfig(
        driver="ODBC Driver 18 for SQL Server",
        server="localhost",
        database="master",
        username="sa",
        password="secret",
    )

    assert config.connection_string == (
        "DRIVER={ODBC Driver 18 for SQL Server};"
        "SERVER=localhost;"
        "DATABASE=master;"
        "UID=sa;"
        "PWD=secret;"
        "TrustServerCertificate=yes"
    )
