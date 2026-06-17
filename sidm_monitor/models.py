from __future__ import annotations

from dataclasses import dataclass, replace


@dataclass(frozen=True)
class SessionRow:
    session_id: int
    blocking_session_id: int = 0
    tree: str = ""
    flag: str = ""
    host_name: str = ""
    ip_address: str = ""
    program_name: str = ""
    database_name: str = ""
    command: str = ""
    request_status: str = ""
    session_status: str = ""
    cpu_seconds: int = 0
    wait_seconds: int = 0
    wait_type: str = ""
    wait_resource: str = ""
    sql_text: str = ""
    login_name: str = ""
    kill_result: str = ""

    def with_display(self, tree: str, flag: str = "") -> SessionRow:
        return replace(self, tree=tree, flag=flag)

    def with_kill_result(self, kill_result: str) -> SessionRow:
        return replace(self, kill_result=kill_result)
