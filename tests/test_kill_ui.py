from sidm_monitor.app import ROOT_BLOCKER_FLAG, build_kill_confirmation
from sidm_monitor.models import SessionRow


def test_kill_confirmation_for_root_blocker_has_no_non_root_warning() -> None:
    message = build_kill_confirmation(
        SessionRow(
            session_id=57,
            flag=ROOT_BLOCKER_FLAG,
            host_name="host-a",
            login_name="sa",
            program_name="SSMS",
            wait_seconds=61,
            sql_text="update dbo.lock_test_codex set name = N'x'",
        )
    )

    assert "不是根阻塞进程" not in message
    assert "会话：57" in message
    assert "update dbo.lock_test_codex" in message


def test_kill_confirmation_warns_for_non_root_session() -> None:
    message = build_kill_confirmation(SessionRow(session_id=58, flag="", sql_text="select 1"))

    assert "不是根阻塞进程" in message
    assert "会话：58" in message
