from sidm_monitor.locks import build_lock_tree, has_blocking, max_wait_seconds
from sidm_monitor.models import SessionRow


def row(session_id: int, blocking_session_id: int, wait_seconds: int = 0) -> SessionRow:
    return SessionRow(
        session_id=session_id,
        blocking_session_id=blocking_session_id,
        host_name=f"host-{session_id}",
        wait_seconds=wait_seconds,
        sql_text=f"select {session_id}",
    )


def test_build_lock_tree_marks_root_blockers_and_orders_children() -> None:
    rows = [
        row(62, 0),
        row(99, 62, 12),
        row(253, 62, 18),
        row(254, 253, 7),
        row(381, 62, 1),
        row(826, 62, 2),
        row(1016, 62, 3),
        row(614, 253, 20),
        row(2004, 614, 4),
        row(281, 826, 5),
        row(2000, 614, 6),
        row(2001, 253, 9),
        row(2003, 2001, 11),
        row(63, 0),
        row(20, 63, 13),
        row(30, 63, 14),
        row(40, 20, 15),
        row(50, 30, 16),
        row(60, 30, 17),
        row(70, 60, 18),
        row(80, 50, 19),
    ]

    ordered = build_lock_tree(rows)

    assert [item.session_id for item in ordered[:3]] == [62, 99, 253]
    assert ordered[0].tree == "*62"
    assert ordered[0].flag == "◆"
    assert ordered[1].tree.endswith("*99")
    assert ordered[2].tree.endswith("*253")
    assert ordered[2].tree.startswith("├-")
    assert [item.session_id for item in ordered[-8:-5]] == [63, 20, 40]
    assert ordered[-8].flag == "◆"


def test_standalone_sessions_are_not_marked_as_blockers() -> None:
    ordered = build_lock_tree([row(11, 0), row(12, 0)])

    assert [item.tree for item in ordered] == ["*11", "*12"]
    assert [item.flag for item in ordered] == ["", ""]
    assert has_blocking(ordered) is False


def test_has_blocking_and_max_wait_seconds() -> None:
    ordered = build_lock_tree([row(10, 0), row(20, 10, 35), row(30, 10, 9)])

    assert has_blocking(ordered) is True
    assert max_wait_seconds(ordered) == 35
