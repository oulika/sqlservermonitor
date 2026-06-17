# Git artifact cleanup design

## Goal

Reduce the unpushed initial commit so it can be uploaded reliably to GitHub, while preserving local build outputs and machine-specific files.

## Scope

Remove `build/`, `dist/`, `log/`, and `config.ini` from Git tracking. Add these paths to `.gitignore`. Keep source code, tests, documentation, assets, and `config.example.ini` tracked.

## Safety

The files are removed from the Git index only; they stay on disk. The only rewritten commit is local and has not been pushed. The original commit remains recoverable through the reflog until normal Git maintenance prunes it.

## Verification

Confirm the ignore rules work, confirm the rewritten commit has no paths in the cleanup scope, and push `main` to `origin`.
