# wxPython UI Polish Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace the rough wxPython monitor window with a professional operations-tool layout.

**Architecture:** Keep all database and monitoring logic unchanged. Rework `sidm_monitor/app.py` so the frame has a header toolbar, KPI summary row, split table/details area, stable Chinese labels, and clearer status/error presentation.

**Tech Stack:** Python, wxPython, pytest.

---

### Task 1: Stabilize UI Text and Formatting

**Files:**
- Modify: `sidm_monitor/app.py`
- Test: `tests/test_app_formatting.py`

**Steps:**
1. Add tests for Chinese date formatting and display-safe row constants.
2. Replace corrupted Chinese strings in `app.py`.
3. Avoid locale-sensitive `strftime`.
4. Run `python -m pytest tests/test_app_formatting.py -v`.

### Task 2: Rebuild Layout

**Files:**
- Modify: `sidm_monitor/app.py`

**Steps:**
1. Add a compact top header with server, connection state, refresh button, log button, and auto-unlock controls.
2. Add a summary strip for session count, blocker count, max wait, and last refresh.
3. Use `wx.SplitterWindow` for grid and lower detail area.
4. Add alert text and selected SQL detail fields.

### Task 3: Polish Table Behavior

**Files:**
- Modify: `sidm_monitor/app.py`

**Steps:**
1. Set grid label colors, row label width, default row height, and fonts.
2. Apply consistent row colors for root blocker, blocked child, and normal rows.
3. Show selected row SQL in the detail pane.
4. Keep right-click copy behavior.

### Task 4: Verify

**Files:**
- All tests

**Steps:**
1. Run `python -m pytest -v`.
2. Run `python -m sidm_monitor` where wxPython is available.
3. If local wxPython is unavailable, verify import and report that GUI launch must be checked on the user's environment.
