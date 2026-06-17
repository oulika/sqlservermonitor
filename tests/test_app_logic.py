from sidm_monitor.app import blocked_wait_seconds_by_root
from sidm_monitor.models import SessionRow


def test_blocked_wait_seconds_by_root_uses_max_child_wait() -> None:
    waits = blocked_wait_seconds_by_root(
        [
            SessionRow(session_id=10, blocking_session_id=0),
            SessionRow(session_id=20, blocking_session_id=10, wait_seconds=5),
            SessionRow(session_id=30, blocking_session_id=10, wait_seconds=60),
            SessionRow(session_id=40, blocking_session_id=10, wait_seconds=12),
        ]
    )

    assert waits == {10: 60}
