# Git artifact cleanup Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Rewrite the unpushed commit without generated artifacts, local configuration, or runtime logs, then push it to GitHub.

**Architecture:** Keep generated and local-only paths on disk while removing them from the Git index. Add root ignore rules, amend the unpushed commit, and verify the remote branch advances.

**Tech Stack:** Git, PowerShell, GitHub HTTPS remote.

---

### Task 1: Add repository ignore rules

**Files:**
- Create: `.gitignore`

**Step 1: Add the exact local-only paths**

```gitignore
build/
dist/
log/
config.ini
```

**Step 2: Verify the rules**

Run: `git check-ignore -v build dist log config.ini`
Expected: every path resolves to `.gitignore`.

### Task 2: Remove generated and local files from the index

**Files:**
- Modify: Git index only

**Step 1: Remove paths from tracking without deleting files**

Run: `git rm --cached -r --ignore-unmatch build dist log config.ini`
Expected: paths are staged as deletions while their working-tree files remain present.

**Step 2: Verify local files exist and no scoped paths remain staged for addition**

Run: `Test-Path build; Test-Path dist; Test-Path log; Test-Path config.ini; git diff --cached --name-only`
Expected: each local path is present and the staged diff contains deletions for the cleanup scope.

### Task 3: Amend and push the unpushed commit

**Files:**
- Modify: local `main` commit

**Step 1: Amend the existing unpushed commit**

Run: `git add .gitignore docs/plans/2026-10-21-git-artifact-cleanup-design.md docs/plans/2026-10-21-git-artifact-cleanup-implementation.md; git commit --amend --no-edit`
Expected: a new local commit replaces `ed4a855`.

**Step 2: Inspect the rewritten commit**

Run: `git show --stat --oneline HEAD; git ls-tree -r --name-only HEAD | rg '^(build/|dist/|log/|config.ini$)'`
Expected: no matching tracked paths.

**Step 3: Push and verify**

Run: `git push origin main; git status --short --branch`
Expected: `main` is synchronized with `origin/main`.
