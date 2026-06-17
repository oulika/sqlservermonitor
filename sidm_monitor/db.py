from __future__ import annotations

from typing import Any, Callable, Protocol

from sidm_monitor.config import AppConfig
from sidm_monitor.models import SessionRow


SESSION_QUERY = """
SELECT
    S.session_id AS [session_id],
    ISNULL(R.blocking_session_id, 0) AS [blocking_session_id],
    S.host_name AS [host_name],
    C.client_net_address AS [ip_address],
    S.program_name AS [program_name],
    DB_NAME(COALESCE(R.database_id, S.database_id)) AS [database_name],
    COALESCE(R.command, 'AWAITING COMMAND') AS [command],
    COALESCE(R.status, S.status) AS [request_status],
    S.status AS [session_status],
    S.cpu_time / 1000 AS [cpu_seconds],
    ISNULL(R.wait_time, 0) / 1000 AS [wait_seconds],
    COALESCE(R.last_wait_type, '') AS [wait_type],
    COALESCE(R.wait_resource, '') AS [wait_resource],
    COALESCE(
        SUBSTRING(
            CONVERT(varchar(8000), RequestSql.text),
            R.statement_start_offset / 2 + 1,
            CASE
                WHEN R.statement_end_offset = -1 THEN LEN(RequestSql.text)
                ELSE (R.statement_end_offset - R.statement_start_offset) / 2 + 1
            END
        ),
        CONVERT(varchar(8000), InputBuffer.event_info),
        CONVERT(varchar(8000), ConnectionSql.text),
        ''
    ) AS [sql_text],
    S.login_name AS [login_name]
FROM sys.dm_exec_sessions S WITH (NOLOCK)
LEFT JOIN sys.dm_exec_connections C WITH (NOLOCK)
    ON S.session_id = C.session_id
LEFT JOIN sys.dm_exec_requests R WITH (NOLOCK)
    ON S.session_id = R.session_id
    AND (C.connection_id = R.connection_id OR C.connection_id IS NULL)
OUTER APPLY sys.dm_exec_sql_text(R.sql_handle) RequestSql
OUTER APPLY sys.dm_exec_input_buffer(S.session_id, R.request_id) InputBuffer
OUTER APPLY sys.dm_exec_sql_text(C.most_recent_sql_handle) ConnectionSql
WHERE
    S.session_id IN (SELECT blocked FROM master..sysprocesses WHERE blocked > 0)
    OR S.session_id IN (SELECT spid FROM master..sysprocesses WHERE blocked > 0)
ORDER BY R.blocking_session_id, S.session_id
"""


class CursorLike(Protocol):
    def execute(self, sql: str, *params: object) -> CursorLike:
        ...

    def fetchall(self) -> list[Any]:
        ...


class ConnectionLike(Protocol):
    def cursor(self) -> CursorLike:
        ...

    def close(self) -> None:
        ...


Connector = Callable[[str, bool], ConnectionLike]


class SqlServerMonitorRepository:
    def __init__(self, config: AppConfig, connector: Connector | None = None) -> None:
        self._config = config
        self._connector = connector or _pyodbc_connect
        self._connection: ConnectionLike | None = None

    def connect(self) -> None:
        self._connection = self._connector(self._config.connection_string, True)

    def disconnect(self) -> None:
        if self._connection is not None:
            self._connection.close()
            self._connection = None

    def is_connected(self) -> bool:
        return self._connection is not None

    def fetch_sessions(self) -> list[SessionRow]:
        connection = self._require_connection()
        cursor = connection.cursor()
        return [map_session_row(row) for row in cursor.execute(SESSION_QUERY).fetchall()]

    def kill_session(self, session_id: int) -> None:
        connection = self._require_connection()
        connection.cursor().execute(f"KILL {int(session_id)}")

    def _require_connection(self) -> ConnectionLike:
        if self._connection is None:
            raise RuntimeError("SQL Server repository is not connected")
        return self._connection


def map_session_row(row: Any) -> SessionRow:
    return SessionRow(
        session_id=_int(_get(row, "session_id")),
        blocking_session_id=_int(_get(row, "blocking_session_id")),
        host_name=_str(_get(row, "host_name")),
        ip_address=_str(_get(row, "ip_address")),
        program_name=_str(_get(row, "program_name")),
        database_name=_str(_get(row, "database_name")),
        command=_str(_get(row, "command")),
        request_status=_str(_get(row, "request_status")),
        session_status=_str(_get(row, "session_status")),
        cpu_seconds=_int(_get(row, "cpu_seconds")),
        wait_seconds=_int(_get(row, "wait_seconds")),
        wait_type=_str(_get(row, "wait_type")),
        wait_resource=_str(_get(row, "wait_resource")),
        sql_text=_str(_get(row, "sql_text")),
        login_name=_str(_get(row, "login_name")),
    )


def _pyodbc_connect(connection_string: str, autocommit: bool) -> ConnectionLike:
    import pyodbc

    return pyodbc.connect(connection_string, autocommit=autocommit)


def _get(row: Any, name: str) -> Any:
    if isinstance(row, dict):
        return row.get(name)

    if hasattr(row, name):
        return getattr(row, name)

    raise AttributeError(f"row has no column {name!r}")


def _str(value: Any) -> str:
    return "" if value is None else str(value)


def _int(value: Any) -> int:
    if value is None or value == "":
        return 0
    return int(value)
