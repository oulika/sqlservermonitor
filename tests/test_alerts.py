from datetime import datetime

from sidm_monitor.alerts import build_alert_text
from sidm_monitor.locks import build_lock_tree
from sidm_monitor.models import SessionRow


def test_build_alert_text_formats_blocking_sessions() -> None:
    rows = build_lock_tree(
        [
            SessionRow(session_id=62, blocking_session_id=0, host_name="srv", login_name="sa"),
            SessionRow(
                session_id=99,
                blocking_session_id=62,
                host_name="client",
                program_name="app",
                database_name="his",
                login_name="user1",
                wait_seconds=12,
                sql_text="",
            ),
        ]
    )

    text = build_alert_text(rows, datetime(2026, 6, 16, 9, 30, 5))

    assert "2026.06.16 09:30:05 共 2 个会话 最长等待时间:12" in text
    assert "◆ 计算机：srv" in text
    assert "   计算机：client" in text
    assert "用户：user1" in text
    assert "数据库：his" in text
    assert "应用程序：app" in text
    assert "sql命令：" in text
    assert "未取到" in text


def test_build_alert_text_returns_empty_string_without_blocking() -> None:
    rows = build_lock_tree([SessionRow(session_id=1), SessionRow(session_id=2)])

    assert build_alert_text(rows, datetime(2026, 6, 16, 9, 30, 5)) == ""
