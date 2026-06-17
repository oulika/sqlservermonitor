from __future__ import annotations

from collections import defaultdict
from collections.abc import Sequence

from sidm_monitor.models import SessionRow


def build_lock_tree(rows: Sequence[SessionRow]) -> list[SessionRow]:
    children_by_blocker: dict[int, list[SessionRow]] = defaultdict(list)
    by_session: dict[int, SessionRow] = {}

    for row in rows:
        by_session[row.session_id] = row
        if row.blocking_session_id:
            children_by_blocker[row.blocking_session_id].append(row)

    for children in children_by_blocker.values():
        children.sort(key=lambda item: item.session_id)

    ordered: list[SessionRow] = []
    visited: set[int] = set()

    roots = sorted(
        (
            row
            for row in rows
            if row.session_id in children_by_blocker
            and (row.blocking_session_id == 0 or row.blocking_session_id not in by_session)
        ),
        key=lambda item: item.session_id,
    )

    def visit(row: SessionRow, prefix_parts: tuple[bool, ...]) -> None:
        if row.session_id in visited:
            return
        visited.add(row.session_id)

        is_root = len(prefix_parts) == 0
        has_children = row.session_id in children_by_blocker
        flag = "◆" if is_root and has_children else ""
        tree = _format_tree(row.session_id, prefix_parts)
        ordered.append(row.with_display(tree=tree, flag=flag))

        children = children_by_blocker.get(row.session_id, [])
        for index, child in enumerate(children):
            visit(child, prefix_parts + (index < len(children) - 1,))

    for root in roots:
        visit(root, ())

    for row in sorted(rows, key=lambda item: item.session_id):
        if row.session_id not in visited:
            ordered.append(row.with_display(tree=f"*{row.session_id}", flag=""))

    return ordered


def has_blocking(rows: Sequence[SessionRow]) -> bool:
    return any(row.flag == "◆" for row in rows)


def max_wait_seconds(rows: Sequence[SessionRow]) -> int:
    return max((row.wait_seconds for row in rows), default=0)


def _format_tree(session_id: int, prefix_parts: tuple[bool, ...]) -> str:
    if not prefix_parts:
        return f"*{session_id}"

    prefix = "".join("│ " if has_more else "   " for has_more in prefix_parts[:-1])
    branch = "├-" if prefix_parts[-1] else "└-"
    return f"{prefix}{branch}*{session_id}"
