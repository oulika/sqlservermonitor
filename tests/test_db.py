from types import SimpleNamespace

from sidm_monitor.config import AppConfig
from sidm_monitor.db import SESSION_QUERY, SqlServerMonitorRepository, map_session_row


class FakeCursor:
    def __init__(self) -> None:
        self.executed: list[tuple[str, tuple[object, ...]]] = []
        self.rows: list[object] = []

    def execute(self, sql: str, *params: object) -> "FakeCursor":
        self.executed.append((sql, params))
        return self

    def fetchall(self) -> list[object]:
        return self.rows


class FakeConnection:
    def __init__(self) -> None:
        self.cursor_obj = FakeCursor()
        self.closed = False

    def cursor(self) -> FakeCursor:
        return self.cursor_obj

    def close(self) -> None:
        self.closed = True


def test_repository_uses_config_connection_string_with_autocommit() -> None:
    calls: list[tuple[str, bool]] = []
    config = AppConfig(
        driver="ODBC Driver 18 for SQL Server",
        server="localhost",
        database="master",
        username="sa",
        password="secret",
    )

    def connector(connection_string: str, autocommit: bool) -> FakeConnection:
        calls.append((connection_string, autocommit))
        return FakeConnection()

    repository = SqlServerMonitorRepository(config, connector=connector)
    repository.connect()

    assert calls == [(config.connection_string, True)]
    assert repository.is_connected() is True


def test_kill_session_executes_kill_statement() -> None:
    connection = FakeConnection()
    repository = SqlServerMonitorRepository(
        AppConfig("driver", "server", "database", "user", "pass"),
        connector=lambda _connection_string, _autocommit: connection,
    )
    repository.connect()

    repository.kill_session(62)

    assert connection.cursor_obj.executed == [("KILL 62", ())]


def test_session_query_uses_input_buffer_before_connection_recent_sql() -> None:
    input_buffer_pos = SESSION_QUERY.index("InputBuffer.event_info")
    recent_sql_pos = SESSION_QUERY.index("ConnectionSql.text")

    assert "sys.dm_exec_input_buffer" in SESSION_QUERY
    assert "most_recent_sql_handle" in SESSION_QUERY
    assert input_buffer_pos < recent_sql_pos


def test_map_session_row_handles_database_column_names() -> None:
    raw = SimpleNamespace(
        session_id=62,
        blocking_session_id=0,
        host_name="host",
        ip_address="127.0.0.1",
        program_name="app",
        database_name="master",
        command="SELECT",
        request_status="running",
        session_status="running",
        cpu_seconds=3,
        wait_seconds=12,
        wait_type="LCK_M_X",
        wait_resource="OBJECT: 1",
        sql_text="select 1",
        login_name="sa",
    )

    mapped = map_session_row(raw)

    assert mapped.session_id == 62
    assert mapped.blocking_session_id == 0
    assert mapped.ip_address == "127.0.0.1"
    assert mapped.sql_text == "select 1"
