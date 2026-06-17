from __future__ import annotations

from collections.abc import Sequence
from datetime import datetime

from sidm_monitor.locks import has_blocking, max_wait_seconds
from sidm_monitor.models import SessionRow


def build_alert_text(rows: Sequence[SessionRow], timestamp: datetime) -> str:
    if not has_blocking(rows):
        return ""

    lines = [
        "==================================================================",
        (
            f"{timestamp:%Y.%m.%d %H:%M:%S} 共 {len(rows)} 个会话 "
            f"最长等待时间:{max_wait_seconds(rows)}"
        ),
        "==================================================================",
    ]

    for row in rows:
        if row.flag == "◆":
            prefix = "◆ "
        elif len(row.tree) > 1:
            prefix = "   "
        else:
            continue

        lines.append(
            prefix
            + _label("计算机", row.host_name)
            + _label("用户", row.login_name)
            + f"sid：{row.session_id}  "
            + _label("数据库", row.database_name)
            + _label("应用程序", row.program_name)
            + f"等待时间：{row.wait_seconds}  sql命令："
        )
        lines.append((row.sql_text or "").strip() or "未取到")
        if row.kill_result:
            lines.append(row.kill_result)

    return "\r\n".join(lines)


def _label(name: str, value: str) -> str:
    return f"{name}：{value or ''}  "
