# SQL Server Monitor wxPython Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a wxPython desktop replacement for the PowerBuilder SQL Server blocking-session monitor.

**Architecture:** Keep the UI in `src/sidm_monitor/app.py` and isolate database access, lock-tree transformation, config parsing, and log writing into testable modules. Use the SQL extracted from the PB DataWindow as the base query, then map result rows into Python dataclasses for display and logging.

**Tech Stack:** Python 3, wxPython, pyodbc, openpyxl, pytest.

---

### Task 1: Project Scaffold

**Files:**
- Create: `pyproject.toml`
- Create: `README.md`
- Create: `src/sidm_monitor/__init__.py`
- Create: `src/sidm_monitor/__main__.py`
- Create: `tests/test_imports.py`

**Step 1: Write the failing test**

```python
def test_package_imports() -> None:
    import sidm_monitor

    assert sidm_monitor.__version__
```

**Step 2: Run test to verify it fails**

Run: `python -m pytest tests/test_imports.py -v`

Expected: FAIL because the package does not exist yet.

**Step 3: Write minimal implementation**

Create a package with `__version__ = "0.1.0"` and a `pyproject.toml` declaring dependencies:

- `wxPython`
- `pyodbc`
- `openpyxl`
- `pytest`

**Step 4: Run test to verify it passes**

Run: `python -m pytest tests/test_imports.py -v`

Expected: PASS.

### Task 2: Configuration

**Files:**
- Create: `src/sidm_monitor/config.py`
- Create: `tests/test_config.py`
- Create: `config.example.ini`

**Step 1: Write tests**

Cover:

- Defaults for refresh interval, auto unlock disabled, unlock threshold.
- Reading SQL Server host, database, username, password, driver.
- Creating an ODBC connection string from config.

**Step 2: Implement**

Use `configparser` and a dataclass:

```python
@dataclass(frozen=True)
class AppConfig:
    driver: str
    server: str
    database: str
    username: str
    password: str
    refresh_seconds: int = 10
    auto_unlock: bool = False
    unlock_after_seconds: int = 60
    log_dir: Path = Path("log")
```

**Step 3: Verify**

Run: `python -m pytest tests/test_config.py -v`

Expected: PASS.

### Task 3: Session Model and Lock Tree

**Files:**
- Create: `src/sidm_monitor/models.py`
- Create: `src/sidm_monitor/locks.py`
- Create: `tests/test_locks.py`

**Step 1: Write tests**

Use the PB test data from `w_link.srw` retrieve-end logic:

- Root blockers are marked with `◆`.
- Children are ordered below their blocker.
- Tree labels use `*<session_id>` and branch prefixes.
- Non-blocked standalone sessions are not marked as blocker roots.

**Step 2: Implement**

Create `SessionRow` dataclass and pure functions:

- `build_lock_tree(rows: Sequence[SessionRow]) -> list[SessionRow]`
- `has_blocking(rows: Sequence[SessionRow]) -> bool`
- `max_wait_seconds(rows: Sequence[SessionRow]) -> int`

**Step 3: Verify**

Run: `python -m pytest tests/test_locks.py -v`

Expected: PASS.

### Task 4: Alert Text

**Files:**
- Create: `src/sidm_monitor/alerts.py`
- Create: `tests/test_alerts.py`

**Step 1: Write tests**

Cover formatting equivalent to the PB multiline alert:

- Header includes timestamp, session count, and max wait.
- Root blockers start with `◆`.
- Blocked children are indented.
- Empty SQL text becomes `未取到`.

**Step 2: Implement**

Implement:

```python
def build_alert_text(rows: Sequence[SessionRow], timestamp: datetime) -> str:
    ...
```

**Step 3: Verify**

Run: `python -m pytest tests/test_alerts.py -v`

Expected: PASS.

### Task 5: Database Access

**Files:**
- Create: `src/sidm_monitor/db.py`
- Create: `tests/test_db.py`

**Step 1: Write tests**

Test connection string construction and row mapping without opening a real database connection.

**Step 2: Implement**

Create `SqlServerMonitorRepository` with:

- `connect()`
- `disconnect()`
- `is_connected()`
- `fetch_sessions() -> list[SessionRow]`
- `kill_session(session_id: int) -> None`

Use the query from `sidm/d_link_sqlserver_2005.srd` as the base SQL.

**Step 3: Verify**

Run: `python -m pytest tests/test_db.py -v`

Expected: PASS.

### Task 6: Log Writers

**Files:**
- Create: `src/sidm_monitor/logging_io.py`
- Create: `tests/test_logging_io.py`

**Step 1: Write tests**

Cover:

- Text log path `YYYY.MM.DD_<server>.txt`.
- First append writes a start marker when needed.
- XLSX append creates headers and appends lock rows.

**Step 2: Implement**

Use `Path.open(..., encoding="utf-8")` for text logs and `openpyxl` for xlsx logs.

**Step 3: Verify**

Run: `python -m pytest tests/test_logging_io.py -v`

Expected: PASS.

### Task 7: wxPython UI

**Files:**
- Create: `src/sidm_monitor/app.py`
- Modify: `src/sidm_monitor/__main__.py`

**Step 1: Implement UI shell**

Create:

- `MonitorFrame(wx.Frame)`
- menu bar
- session grid
- alert text box
- refresh and auto-unlock controls
- status bar
- timer

**Step 2: Wire refresh flow**

On timer:

1. Fetch sessions.
2. Build lock tree.
3. Update grid.
4. Build alert text for blocking rows.
5. Write logs when max wait exceeds 10 seconds.
6. Optionally kill root blockers when auto-unlock is enabled.

**Step 3: Add right-click SQL view**

Right-click a row to show full SQL in a dialog and copy it to the clipboard.

**Step 4: Manual verify**

Run: `python -m sidm_monitor`

Expected: The desktop window opens. Without a configured server, it shows disconnected state instead of crashing.

### Task 8: Documentation and Final Verification

**Files:**
- Modify: `README.md`

**Step 1: Document setup**

Document:

- Python version.
- Installing dependencies.
- SQL Server ODBC driver requirement.
- Copying `config.example.ini` to `config.ini`.
- Running `python -m sidm_monitor`.
- Safety note for auto-unlock.

**Step 2: Run full tests**

Run: `python -m pytest -v`

Expected: PASS.

**Step 3: Manual run**

Run: `python -m sidm_monitor`

Expected: UI launches.
