# Right Click Kill Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a right-click context menu that can view SQL, copy SQL, and kill the selected SQL Server session after confirmation.

**Architecture:** Keep `SqlServerMonitorRepository.kill_session()` as the only database mutation path. Add UI-only helpers in `sidm_monitor/app.py` to build a safe confirmation message, execute `KILL`, update status, and refresh.

**Tech Stack:** Python, wxPython, pyodbc, pytest.

---

### Task 1: Test Confirmation Text

**Files:**
- Modify: `sidm_monitor/app.py`
- Create: `tests/test_kill_ui.py`

**Steps:**
1. Add a pure helper to build the Kill confirmation message.
2. Test root blocker and non-root warning text.
3. Run `python -m pytest tests/test_kill_ui.py -v`.

### Task 2: Add Context Menu

**Files:**
- Modify: `sidm_monitor/app.py`

**Steps:**
1. Replace direct right-click message box with a `wx.Menu`.
2. Add menu items: `查看 SQL`, `复制 SQL`, `Kill 解锁`.
3. Bind each menu item to the selected row.

### Task 3: Execute Kill

**Files:**
- Modify: `sidm_monitor/app.py`

**Steps:**
1. Show confirmation dialog before killing.
2. Call `repository.kill_session(session_id)`.
3. Show success/failure in status bar.
4. Refresh immediately after success.

### Task 4: Verify and Rebuild

**Files:**
- Build output

**Steps:**
1. Run full tests.
2. Build a new exe.
3. Zip the build output.
