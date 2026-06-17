from __future__ import annotations

from collections.abc import Sequence
from datetime import datetime
from pathlib import Path
import sys
from typing import Any

from sidm_monitor.alerts import build_alert_text
from sidm_monitor.config import AppConfig, load_config
from sidm_monitor.db import SqlServerMonitorRepository
from sidm_monitor.locks import build_lock_tree, has_blocking, max_wait_seconds
from sidm_monitor.logging_io import append_text_log, append_xlsx_log
from sidm_monitor.models import SessionRow

try:
    import wx
    import wx.grid as gridlib
except ImportError:  # pragma: no cover - depends on local desktop env
    wx = None
    gridlib = None


ROOT_BLOCKER_FLAG = "◆"
TREE_BRANCH_PREFIXES = ("├", "└", "│")

APP_ICON_RELATIVE_PATH = Path("assets") / "red_skull_icon.ico"

GRID_COLUMNS = [
    ("tree", "锁树", 138),
    ("flag", "标志", 52),
    ("session_id", "会话", 72),
    ("blocking_session_id", "锁会话", 72),
    ("host_name", "主机名", 132),
    ("ip_address", "IP 地址", 116),
    ("program_name", "应用名", 168),
    ("database_name", "数据库", 106),
    ("session_status", "状态", 82),
    ("cpu_seconds", "CPU", 62),
    ("wait_seconds", "等待秒", 74),
    ("wait_type", "等待类型", 132),
    ("wait_resource", "等待资源", 180),
    ("sql_text", "SQL 语句", 300),
    ("login_name", "登录名", 108),
    ("kill_result", "中断", 62),
]


def blocked_wait_seconds_by_root(rows: Sequence[SessionRow]) -> dict[int, int]:
    waits: dict[int, int] = {}
    for row in rows:
        if row.blocking_session_id:
            waits[row.blocking_session_id] = max(
                waits.get(row.blocking_session_id, 0),
                row.wait_seconds,
            )
    return waits


def count_root_blockers(rows: Sequence[SessionRow]) -> int:
    return sum(1 for row in rows if row.flag == ROOT_BLOCKER_FLAG)


def format_chinese_datetime(value: datetime) -> str:
    return (
        f"{value.year:04d}年{value.month:02d}月{value.day:02d}日 "
        f"{value.hour:02d}:{value.minute:02d}:{value.second:02d}"
    )


def format_compact_datetime(value: datetime) -> str:
    return (
        f"{value.year:04d}-{value.month:02d}-{value.day:02d} "
        f"{value.hour:02d}:{value.minute:02d}:{value.second:02d}"
    )


def app_resource_path(relative_path: Path) -> Path:
    if getattr(sys, "frozen", False):
        base_path = Path(getattr(sys, "_MEIPASS", Path(sys.executable).resolve().parent))
    else:
        base_path = Path(__file__).resolve().parent.parent
    return base_path / relative_path


def app_icon_path() -> Path:
    return app_resource_path(APP_ICON_RELATIVE_PATH)


def build_kill_confirmation(row: SessionRow) -> str:
    warning = ""
    if row.flag != ROOT_BLOCKER_FLAG:
        warning = "注意：当前行不是根阻塞进程，Kill 它可能无法解除整棵锁树。\n\n"

    sql_preview = (row.sql_text or "未取到").strip()
    if len(sql_preview) > 500:
        sql_preview = sql_preview[:500] + "..."

    return (
        warning
        + "确认要 Kill 这个 SQL Server 会话吗？\n\n"
        + f"会话：{row.session_id}\n"
        + f"锁会话：{row.blocking_session_id}\n"
        + f"主机：{row.host_name}\n"
        + f"登录名：{row.login_name}\n"
        + f"应用名：{row.program_name}\n"
        + f"等待时间：{row.wait_seconds} 秒\n\n"
        + "SQL 摘要：\n"
        + sql_preview
    )


def run_app(config_path: str | Path = "config.ini") -> None:
    if wx is None:
        raise RuntimeError(
            "wxPython is not installed. Install dependencies with "
            "`python -m pip install -e .[dev]` or `python -m pip install wxPython`."
        )

    app = wx.App(False)
    frame = MonitorFrame(load_config(config_path), Path(config_path))
    app.SetTopWindow(frame)
    frame.Show()
    app.MainLoop()


if wx is not None:

    class MonitorFrame(wx.Frame):
        def __init__(self, config: AppConfig, config_path: Path) -> None:
            super().__init__(
                None,
                title=f"SQL Server 进程监控 - {config.server}",
                size=(1360, 820),
            )
            self._set_window_icon()
            self.config = config
            self.config_path = config_path
            self.repository = SqlServerMonitorRepository(config)
            self.rows: list[SessionRow] = []
            self._last_log_text = ""

            self.timer = wx.Timer(self)
            self.Bind(wx.EVT_TIMER, self.on_timer, self.timer)
            self.Bind(wx.EVT_CLOSE, self.on_close)

            self._init_palette()
            self._build_menu()
            self._build_layout()
            self.CreateStatusBar()
            self._set_status("未连接")

            if self.config_path.exists():
                self.connect()
            else:
                self._set_status("未找到 config.ini，请从 config.example.ini 复制并修改配置")

        def _set_window_icon(self) -> None:
            icon_file = app_icon_path()
            if icon_file.exists():
                self.SetIcon(wx.Icon(str(icon_file), wx.BITMAP_TYPE_ICO))

        def _init_palette(self) -> None:
            self.bg = wx.Colour(245, 247, 250)
            self.panel_bg = wx.Colour(255, 255, 255)
            self.border = wx.Colour(214, 220, 228)
            self.header_bg = wx.Colour(235, 239, 245)
            self.text = wx.Colour(34, 40, 49)
            self.muted = wx.Colour(93, 102, 116)
            self.root_bg = wx.Colour(255, 230, 230)
            self.child_bg = wx.Colour(242, 245, 249)
            self.wait_bg = wx.Colour(255, 247, 214)
            self.ok_bg = wx.Colour(224, 245, 234)
            self.error_bg = wx.Colour(255, 232, 232)

        def _build_menu(self) -> None:
            menu_bar = wx.MenuBar()
            system_menu = wx.Menu()

            connect_item = system_menu.Append(wx.ID_ANY, "连接数据库")
            self.Bind(wx.EVT_MENU, self.on_connect, connect_item)

            refresh_item = system_menu.Append(wx.ID_REFRESH, "立即刷新")
            self.Bind(wx.EVT_MENU, self.on_refresh_now, refresh_item)

            open_log_item = system_menu.Append(wx.ID_ANY, "打开日志目录")
            self.Bind(wx.EVT_MENU, self.on_open_log_dir, open_log_item)

            system_menu.AppendSeparator()
            exit_item = system_menu.Append(wx.ID_EXIT, "退出")
            self.Bind(wx.EVT_MENU, lambda _event: self.Close(), exit_item)

            menu_bar.Append(system_menu, "系统(&S)")
            self.SetMenuBar(menu_bar)

        def _build_layout(self) -> None:
            root_panel = wx.Panel(self)
            root_panel.SetBackgroundColour(self.bg)
            root = wx.BoxSizer(wx.VERTICAL)

            root.Add(self._build_header(root_panel), 0, wx.EXPAND | wx.ALL, 10)
            root.Add(self._build_summary(root_panel), 0, wx.EXPAND | wx.LEFT | wx.RIGHT | wx.BOTTOM, 10)
            root.Add(self._build_main_area(root_panel), 1, wx.EXPAND | wx.LEFT | wx.RIGHT | wx.BOTTOM, 10)

            root_panel.SetSizer(root)

        def _build_header(self, parent: Any) -> Any:
            panel = wx.Panel(parent)
            panel.SetBackgroundColour(self.panel_bg)
            sizer = wx.BoxSizer(wx.HORIZONTAL)

            title_box = wx.BoxSizer(wx.VERTICAL)
            title = wx.StaticText(panel, label="SQL Server 进程监控")
            title.SetFont(wx.Font(14, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD))
            subtitle = wx.StaticText(panel, label=f"服务器：{self.config.server}    数据库：{self.config.database}")
            subtitle.SetForegroundColour(self.muted)
            title_box.Add(title, 0, wx.BOTTOM, 4)
            title_box.Add(subtitle, 0)
            sizer.Add(title_box, 1, wx.ALIGN_CENTER_VERTICAL | wx.ALL, 12)

            self.connection_badge = wx.StaticText(panel, label="未连接")
            self.connection_badge.SetBackgroundColour(self.error_bg)
            self.connection_badge.SetForegroundColour(wx.Colour(150, 42, 42))
            sizer.Add(self.connection_badge, 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 12)

            self.refresh_button = wx.Button(panel, label="刷新")
            self.refresh_button.Bind(wx.EVT_BUTTON, self.on_refresh_now)
            sizer.Add(self.refresh_button, 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 8)

            log_button = wx.Button(panel, label="日志")
            log_button.Bind(wx.EVT_BUTTON, self.on_open_log_dir)
            sizer.Add(log_button, 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 16)

            sizer.Add(wx.StaticText(panel, label="刷新"), 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 4)
            self.refresh_spin = wx.SpinCtrl(panel, min=1, max=3600, initial=self.config.refresh_seconds, size=(74, -1))
            sizer.Add(self.refresh_spin, 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 4)
            sizer.Add(wx.StaticText(panel, label="秒"), 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 14)

            sizer.Add(wx.StaticText(panel, label="自动解锁阈值"), 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 4)
            self.unlock_spin = wx.SpinCtrl(panel, min=1, max=86400, initial=self.config.unlock_after_seconds, size=(82, -1))
            sizer.Add(self.unlock_spin, 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 4)
            sizer.Add(wx.StaticText(panel, label="秒"), 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 8)
            self.auto_unlock = wx.CheckBox(panel, label="启用")
            self.auto_unlock.SetValue(self.config.auto_unlock)
            sizer.Add(self.auto_unlock, 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 12)

            panel.SetSizer(sizer)
            return panel

        def _build_summary(self, parent: Any) -> Any:
            panel = wx.Panel(parent)
            panel.SetBackgroundColour(self.bg)
            sizer = wx.BoxSizer(wx.HORIZONTAL)

            self.session_value = self._summary_card(panel, sizer, "会话", "0")
            self.blocker_value = self._summary_card(panel, sizer, "阻塞源", "0")
            self.wait_value = self._summary_card(panel, sizer, "最长等待", "0 秒")
            self.refresh_value = self._summary_card(panel, sizer, "最后刷新", "-")
            self.time_value = self._summary_card(panel, sizer, "本机时间", format_chinese_datetime(datetime.now()))

            panel.SetSizer(sizer)
            return panel

        def _summary_card(self, parent: Any, sizer: Any, label: str, value: str) -> Any:
            card = wx.Panel(parent)
            card.SetBackgroundColour(self.panel_bg)
            box = wx.BoxSizer(wx.VERTICAL)
            label_ctrl = wx.StaticText(card, label=label)
            label_ctrl.SetForegroundColour(self.muted)
            value_ctrl = wx.StaticText(card, label=value)
            value_ctrl.SetForegroundColour(self.text)
            value_ctrl.SetFont(wx.Font(12, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD))
            box.Add(label_ctrl, 0, wx.BOTTOM, 5)
            box.Add(value_ctrl, 0)
            card.SetSizer(box)
            sizer.Add(card, 1, wx.RIGHT | wx.EXPAND, 8)
            return value_ctrl

        def _build_main_area(self, parent: Any) -> Any:
            splitter = wx.SplitterWindow(parent, style=wx.SP_LIVE_UPDATE | wx.SP_3DSASH)

            grid_panel = wx.Panel(splitter)
            grid_panel.SetBackgroundColour(self.panel_bg)
            grid_sizer = wx.BoxSizer(wx.VERTICAL)
            grid_title = wx.StaticText(grid_panel, label="会话列表")
            grid_title.SetFont(wx.Font(11, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD))
            grid_sizer.Add(grid_title, 0, wx.ALL, 8)

            self.grid = gridlib.Grid(grid_panel)
            self.grid.CreateGrid(0, len(GRID_COLUMNS))
            self._configure_grid()
            self.grid.Bind(gridlib.EVT_GRID_CELL_RIGHT_CLICK, self.on_grid_right_click)
            self.grid.Bind(gridlib.EVT_GRID_SELECT_CELL, self.on_grid_select_cell)
            grid_sizer.Add(self.grid, 1, wx.EXPAND | wx.LEFT | wx.RIGHT | wx.BOTTOM, 8)
            grid_panel.SetSizer(grid_sizer)

            detail_panel = wx.Panel(splitter)
            detail_panel.SetBackgroundColour(self.panel_bg)
            detail_sizer = wx.BoxSizer(wx.HORIZONTAL)

            alert_box = wx.BoxSizer(wx.VERTICAL)
            alert_title = wx.StaticText(detail_panel, label="阻塞报警")
            alert_title.SetFont(wx.Font(10, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD))
            self.alert_text = wx.TextCtrl(
                detail_panel,
                style=wx.TE_MULTILINE | wx.TE_READONLY | wx.HSCROLL | wx.BORDER_SIMPLE,
            )
            self.alert_text.SetFont(wx.Font(9, wx.FONTFAMILY_TELETYPE, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_NORMAL))
            alert_box.Add(alert_title, 0, wx.BOTTOM, 6)
            alert_box.Add(self.alert_text, 1, wx.EXPAND)

            sql_box = wx.BoxSizer(wx.VERTICAL)
            sql_title = wx.StaticText(detail_panel, label="选中 SQL")
            sql_title.SetFont(wx.Font(10, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD))
            self.sql_detail = wx.TextCtrl(
                detail_panel,
                style=wx.TE_MULTILINE | wx.TE_READONLY | wx.HSCROLL | wx.BORDER_SIMPLE,
            )
            self.sql_detail.SetFont(wx.Font(9, wx.FONTFAMILY_TELETYPE, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_NORMAL))
            sql_box.Add(sql_title, 0, wx.BOTTOM, 6)
            sql_box.Add(self.sql_detail, 1, wx.EXPAND)

            detail_sizer.Add(alert_box, 1, wx.EXPAND | wx.ALL, 8)
            detail_sizer.Add(sql_box, 1, wx.EXPAND | wx.TOP | wx.RIGHT | wx.BOTTOM, 8)
            detail_panel.SetSizer(detail_sizer)

            splitter.SplitHorizontally(grid_panel, detail_panel, 500)
            splitter.SetMinimumPaneSize(180)
            return splitter

        def _configure_grid(self) -> None:
            self.grid.EnableEditing(False)
            self.grid.SetRowLabelSize(34)
            self.grid.SetDefaultRowSize(26, resizeExistingRows=True)
            self.grid.SetLabelBackgroundColour(self.header_bg)
            self.grid.SetLabelTextColour(self.text)
            self.grid.SetGridLineColour(self.border)
            self.grid.SetDefaultCellFont(wx.Font(9, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_NORMAL))
            self.grid.SetLabelFont(wx.Font(9, wx.FONTFAMILY_DEFAULT, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_BOLD))
            for index, (_attr, label, width) in enumerate(GRID_COLUMNS):
                self.grid.SetColLabelValue(index, label)
                self.grid.SetColSize(index, width)

        def connect(self) -> None:
            try:
                self.repository.connect()
            except Exception as exc:
                self._set_connection_state(False)
                self._set_status(f"连接失败：{exc}")
                return

            self._set_connection_state(True)
            self._set_status("已连接")
            self._restart_timer()
            self.refresh()

        def on_connect(self, _event: Any) -> None:
            self.connect()

        def on_refresh_now(self, _event: Any) -> None:
            self.timer.Stop()
            self.refresh()

        def on_timer(self, _event: Any) -> None:
            self.refresh()

        def refresh(self) -> None:
            now = datetime.now()
            self.time_value.SetLabel(format_chinese_datetime(now))
            if not self.repository.is_connected():
                self._set_connection_state(False)
                self._set_status("未连接")
                return

            try:
                rows = build_lock_tree(self.repository.fetch_sessions())
            except Exception as exc:
                self._set_connection_state(False)
                self._set_status(f"刷新失败：{exc}")
                return

            self._set_connection_state(True)
            if self.auto_unlock.GetValue():
                rows = self._auto_kill(rows)

            self.rows = rows
            self._update_grid(rows)
            self._update_summary(rows, now)
            alert = build_alert_text(rows, now)
            self.alert_text.SetValue(alert)

            if alert and has_blocking(rows):
                self._play_warning()
                if max_wait_seconds(rows) > 10 and alert != self._last_log_text:
                    self._write_logs(rows, alert)
                    self._last_log_text = alert

            self._set_status(f"刷新完成，会话 {len(rows)} 个")
            self._restart_timer()

        def _auto_kill(self, rows: Sequence[SessionRow]) -> list[SessionRow]:
            threshold = self.unlock_spin.GetValue()
            blocked_waits = blocked_wait_seconds_by_root(rows)
            updated: list[SessionRow] = []
            for row in rows:
                if row.flag == ROOT_BLOCKER_FLAG and blocked_waits.get(row.session_id, 0) >= threshold:
                    try:
                        self.repository.kill_session(row.session_id)
                    except Exception:
                        updated.append(row.with_kill_result("失败"))
                    else:
                        updated.append(row.with_kill_result("中断"))
                else:
                    updated.append(row)
            return updated

        def _write_logs(self, rows: Sequence[SessionRow], alert: str) -> None:
            now = datetime.now()
            try:
                append_text_log(self.config.log_dir, self.config.server, alert + "\r\n", now)
                append_xlsx_log(self.config.log_dir, self.config.server, rows, now)
            except Exception as exc:
                self._set_status(f"写日志失败：{exc}")

        def _update_grid(self, rows: Sequence[SessionRow]) -> None:
            current_rows = self.grid.GetNumberRows()
            if current_rows < len(rows):
                self.grid.AppendRows(len(rows) - current_rows)
            elif current_rows > len(rows):
                self.grid.DeleteRows(0, current_rows - len(rows))

            for row_index, row in enumerate(rows):
                row_bg = self._row_background(row)
                for col_index, (attr, _label, _width) in enumerate(GRID_COLUMNS):
                    value = getattr(row, attr)
                    self.grid.SetCellValue(row_index, col_index, str(value))
                    self.grid.SetCellBackgroundColour(row_index, col_index, row_bg)
                    if attr == "wait_seconds" and row.wait_seconds >= 10:
                        self.grid.SetCellBackgroundColour(row_index, col_index, self.wait_bg)
                    self.grid.SetCellTextColour(row_index, col_index, self.text)
            self.grid.ForceRefresh()

        def _row_background(self, row: SessionRow) -> Any:
            if row.flag == ROOT_BLOCKER_FLAG:
                return self.root_bg
            if row.tree.startswith(TREE_BRANCH_PREFIXES):
                return self.child_bg
            return wx.WHITE

        def _update_summary(self, rows: Sequence[SessionRow], now: datetime) -> None:
            blockers = count_root_blockers(rows)
            max_wait = max_wait_seconds(rows)
            self.session_value.SetLabel(str(len(rows)))
            self.blocker_value.SetLabel(str(blockers))
            self.wait_value.SetLabel(f"{max_wait} 秒")
            self.refresh_value.SetLabel(format_compact_datetime(now))

            if blockers > 0:
                self.blocker_value.SetForegroundColour(wx.Colour(170, 46, 46))
                self.wait_value.SetForegroundColour(wx.Colour(170, 92, 0))
            else:
                self.blocker_value.SetForegroundColour(self.text)
                self.wait_value.SetForegroundColour(self.text)

        def on_grid_select_cell(self, event: Any) -> None:
            self._show_row_sql(event.GetRow())
            event.Skip()

        def on_grid_right_click(self, event: Any) -> None:
            row_index = event.GetRow()
            if row_index < 0 or row_index >= len(self.rows):
                return
            self._show_row_sql(row_index)
            self.grid.SetGridCursor(row_index, max(0, event.GetCol()))
            self._show_context_menu(row_index)

        def _show_context_menu(self, row_index: int) -> None:
            menu = wx.Menu()
            view_item = menu.Append(wx.ID_ANY, "查看 SQL")
            copy_item = menu.Append(wx.ID_ANY, "复制 SQL")
            menu.AppendSeparator()
            kill_item = menu.Append(wx.ID_ANY, "Kill 解锁")

            self.Bind(wx.EVT_MENU, lambda _event: self._view_sql(row_index), view_item)
            self.Bind(wx.EVT_MENU, lambda _event: self._copy_row_sql(row_index), copy_item)
            self.Bind(wx.EVT_MENU, lambda _event: self._confirm_and_kill(row_index), kill_item)

            try:
                self.PopupMenu(menu)
            finally:
                menu.Destroy()

        def _view_sql(self, row_index: int) -> None:
            if row_index < 0 or row_index >= len(self.rows):
                return
            row = self.rows[row_index]
            sql_text = row.sql_text or "未取到"
            self._show_row_sql(row_index)
            wx.MessageBox(sql_text, f"进程 {row.session_id}", wx.OK | wx.ICON_INFORMATION)

        def _copy_row_sql(self, row_index: int) -> None:
            if row_index < 0 or row_index >= len(self.rows):
                return
            row = self.rows[row_index]
            self._copy_to_clipboard(row.sql_text or "未取到")
            self._set_status(f"已复制会话 {row.session_id} 的 SQL")

        def _confirm_and_kill(self, row_index: int) -> None:
            if row_index < 0 or row_index >= len(self.rows):
                return
            row = self.rows[row_index]
            result = wx.MessageBox(
                build_kill_confirmation(row),
                f"Kill 解锁 - 会话 {row.session_id}",
                wx.YES_NO | wx.NO_DEFAULT | wx.ICON_WARNING,
            )
            if result != wx.YES:
                return

            try:
                self.repository.kill_session(row.session_id)
            except Exception as exc:
                self._set_status(f"Kill 会话 {row.session_id} 失败：{exc}")
                wx.MessageBox(
                    f"Kill 会话 {row.session_id} 失败：\n{exc}",
                    "Kill 解锁失败",
                    wx.OK | wx.ICON_ERROR,
                )
                return

            self._set_status(f"已 Kill 会话 {row.session_id}，正在刷新")
            self.refresh()

        def _show_row_sql(self, row_index: int) -> None:
            if row_index < 0 or row_index >= len(self.rows):
                return
            row = self.rows[row_index]
            sql_text = row.sql_text or "未取到"
            header = (
                f"会话：{row.session_id}    锁会话：{row.blocking_session_id}    "
                f"主机：{row.host_name}    用户：{row.login_name}\r\n"
                f"等待：{row.wait_seconds} 秒    类型：{row.wait_type}\r\n"
                "----------------------------------------------------------------\r\n"
            )
            self.sql_detail.SetValue(header + sql_text)

        def on_open_log_dir(self, _event: Any) -> None:
            self.config.log_dir.mkdir(parents=True, exist_ok=True)
            wx.LaunchDefaultApplication(str(self.config.log_dir.resolve()))

        def on_close(self, event: Any) -> None:
            self.timer.Stop()
            self.repository.disconnect()
            event.Skip()

        def _restart_timer(self) -> None:
            seconds = max(1, self.refresh_spin.GetValue())
            self.timer.Start(seconds * 1000, oneShot=True)

        def _set_connection_state(self, connected: bool) -> None:
            if connected:
                self.connection_badge.SetLabel("已连接")
                self.connection_badge.SetBackgroundColour(self.ok_bg)
                self.connection_badge.SetForegroundColour(wx.Colour(32, 116, 72))
            else:
                self.connection_badge.SetLabel("未连接")
                self.connection_badge.SetBackgroundColour(self.error_bg)
                self.connection_badge.SetForegroundColour(wx.Colour(150, 42, 42))

        def _set_status(self, text: str) -> None:
            self.SetStatusText(text)

        def _copy_to_clipboard(self, text: str) -> None:
            if wx.TheClipboard.Open():
                try:
                    wx.TheClipboard.SetData(wx.TextDataObject(text))
                finally:
                    wx.TheClipboard.Close()

        def _play_warning(self) -> None:
            wav_path = Path("warning.wav")
            try:
                import winsound

                if wav_path.exists():
                    winsound.PlaySound(str(wav_path), winsound.SND_FILENAME | winsound.SND_ASYNC)
                else:
                    winsound.MessageBeep(winsound.MB_ICONEXCLAMATION)
            except Exception:
                wx.Bell()

else:

    class MonitorFrame:  # pragma: no cover - only used when dependency missing
        def __init__(self, *_args: object, **_kwargs: object) -> None:
            raise RuntimeError("wxPython is not installed")
