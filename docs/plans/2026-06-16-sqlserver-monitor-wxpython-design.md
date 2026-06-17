# SQL Server Monitor wxPython Design

## Goal

Translate the PowerBuilder SQL Server monitoring tool in `sidm` into a Python desktop application using wxPython, preserving the main SQL Server monitoring workflow.

## Scope

The Python version will migrate the active SQL Server path:

- Connect to SQL Server from configuration.
- Poll SQL Server sessions on a timer.
- Detect blocking and blocked sessions.
- Build and display a lock tree.
- Display current blocking SQL text.
- Write daily text and xlsx logs.
- Optionally kill blocking sessions after a configured wait threshold.
- Play `warning.wav` or a system beep when blocking is detected.

The first version will not migrate hidden or unrelated PowerBuilder paths, including Oracle monitoring, HIS utilities, API demo menus, print setup windows, and visual tray-icon behavior.

## Architecture

The application will use a small layered structure:

- `src/sidm_monitor/config.py` reads configuration and provides defaults.
- `src/sidm_monitor/db.py` owns `pyodbc` connection handling and SQL Server queries.
- `src/sidm_monitor/locks.py` transforms query rows into a lock tree and alert text.
- `src/sidm_monitor/logging_io.py` writes daily `.txt` and `.xlsx` logs.
- `src/sidm_monitor/app.py` contains the wxPython UI and timer orchestration.

The UI stays thin. Database polling and lock-tree construction are kept in testable functions and classes so the risky PowerBuilder behavior can be verified without opening a window.

## UI

The main window will use wxPython:

- `wx.Frame` as the main window.
- A menu bar with connect, monitor mode, log folder, and exit commands.
- `wx.grid.Grid` for session rows.
- A read-only multiline `wx.TextCtrl` for alert SQL text.
- Bottom controls for refresh interval, auto-unlock threshold, auto-unlock checkbox, and current time.
- `wx.Timer` for periodic refresh.

The table will show the PowerBuilder DataWindow columns that matter operationally: lock tree, flag, session id, blocking session id, host, IP, program, database, status, CPU time, wait time, wait type, wait resource, SQL text, login, and kill result.

## Data Flow

At startup the app reads `config.ini`. If it does not exist, the app creates an example file and opens with disconnected state.

When connected, each timer tick:

1. Runs a lightweight connection check.
2. Queries SQL Server session/request/blocking data.
3. Builds the lock tree.
4. Updates the grid.
5. If blocking exists, builds alert text and plays warning sound.
6. If wait time exceeds the logging threshold, appends daily text and xlsx logs.
7. If auto-unlock is enabled, executes `KILL <spid>` for blocking source sessions that meet the threshold.

## SQL

The base query is derived from `sidm/d_link_sqlserver_2005.srd`, using SQL Server DMVs:

- `sys.dm_exec_sessions`
- `sys.dm_exec_connections`
- `sys.dm_exec_requests`
- `sys.dm_exec_sql_text`
- `master..sysprocesses` for compatibility with the original blocked-session filter

The SQL will be centralized in `db.py` so it can be adjusted for specific SQL Server versions.

## Error Handling

Connection failures are shown in the status bar and written to the text log with local time. The app retries on subsequent timer ticks. Query failures do not close the app. Log-writing failures are shown in the status bar and do not stop monitoring.

Auto-unlock failures are recorded per row and included in the alert text.

## Testing

Unit tests will cover:

- Configuration defaults and parsing.
- Lock-tree ordering and root blocker marking.
- Alert text generation.
- Text log file naming and append behavior.
- XLSX log append behavior.

UI behavior will be smoke-tested by importing the wx app module and manually running the app locally.
