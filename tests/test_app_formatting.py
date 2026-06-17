from datetime import datetime

from sidm_monitor.app import format_chinese_datetime


def test_format_chinese_datetime_does_not_use_locale_strftime() -> None:
    assert format_chinese_datetime(datetime(2026, 6, 16, 9, 5, 7)) == (
        "2026年06月16日 09:05:07"
    )
