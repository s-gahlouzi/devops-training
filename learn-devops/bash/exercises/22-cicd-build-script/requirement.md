# Exercise 22: CI/CD Build Script

## Goal

Create a production-ready build script for CI/CD pipelines.

## Requirements

Create `build.sh` that:

1. Uses safe bash options (set -euo pipefail)
2. Validates required environment variables
3. Logs all operations with timestamps
4. Performs these steps:
   - Clean previous build artifacts
   - Check Node.js version
   - Install dependencies (with cache check)
   - Run linter
   - Run tests
   - Build application
   - Generate build report
5. Creates build artifacts in `dist/`
6. Generates `build-info.json` with:
   - Timestamp
   - Git commit SHA
   - Git branch
   - Node version
   - Build status
7. Exits with proper code on failure
8. Cleans up temp files on exit

Create `test-build.sh` that simulates the CI environment and runs build.sh

## Expected Output

```bash
./build.sh

[2026-02-04 10:00:00] ====================================
[2026-02-04 10:00:00] Starting build process
[2026-02-04 10:00:00] ====================================
[2026-02-04 10:00:00] Environment: production
[2026-02-04 10:00:00] Branch: main
[2026-02-04 10:00:00] Commit: abc1234
[2026-02-04 10:00:01] Node version: v20.11.0
[2026-02-04 10:00:01] ====================================
[2026-02-04 10:00:01] Cleaning previous build...
[2026-02-04 10:00:01] Installing dependencies...
[2026-02-04 10:00:15] Running linter...
[2026-02-04 10:00:17] ✓ Lint passed
[2026-02-04 10:00:17] Running tests...
[2026-02-04 10:00:25] ✓ Tests passed (15/15)
[2026-02-04 10:00:25] Building application...
[2026-02-04 10:00:40] ✓ Build completed
[2026-02-04 10:00:40] Generating build report...
[2026-02-04 10:00:40] ====================================
[2026-02-04 10:00:40] Build successful!
[2026-02-04 10:00:40] Build time: 40s
[2026-02-04 10:00:40] Artifacts: dist/
[2026-02-04 10:00:40] ====================================

# build-info.json content:
{
  "timestamp": "2026-02-04T10:00:40Z",
  "commit": "abc1234567890",
  "branch": "main",
  "nodeVersion": "v20.11.0",
  "status": "success",
  "buildDuration": 40
}

# On failure:
[2026-02-04 10:00:20] ✗ Tests failed
[2026-02-04 10:00:20] Build failed after 20s
Exit code: 1
```

## Success Criteria

- Safe bash practices
- Comprehensive logging
- Proper error handling
- Environment validation
- Build info generation
- Cleanup on exit
- CI/CD ready
