# Exercise 24: Semantic Version Bumping

## Goal

Create a script to automatically bump semantic versions for releases.

## Requirements

Create `bump-version.sh` that:

1. Takes version type as argument: `major`, `minor`, or `patch`
2. Reads current version from `package.json`
3. Calculates new version based on semver rules:
   - `major`: 1.2.3 → 2.0.0
   - `minor`: 1.2.3 → 1.3.0
   - `patch`: 1.2.3 → 1.2.4
4. Updates version in multiple files:
   - package.json
   - package-lock.json (if exists)
   - version.txt (create if needed)
5. Creates git commit with conventional message
6. Creates git tag with new version
7. Generates changelog entry
8. Dry-run mode support (--dry-run flag)

Create `get-next-version.sh` that:

1. Analyzes git commits since last tag
2. Determines version bump type from conventional commits:
   - `feat:` → minor
   - `fix:` → patch
   - `BREAKING CHANGE:` → major
3. Outputs next version

Create sample `package.json` for testing

## Expected Behavior

```bash
# Current version: 1.2.3

./bump-version.sh patch
Current version: 1.2.3
New version: 1.2.4
Updated: package.json
Updated: package-lock.json
Updated: version.txt
Created commit: chore: bump version to 1.2.4
Created tag: v1.2.4
Done! New version: 1.2.4

./bump-version.sh minor
Current version: 1.2.4
New version: 1.3.0
...

./bump-version.sh major --dry-run
[DRY RUN] Current version: 1.3.0
[DRY RUN] Would bump to: 2.0.0
[DRY RUN] Would update: package.json
[DRY RUN] Would update: package-lock.json
[DRY RUN] Would create commit: chore: bump version to 2.0.0
[DRY RUN] Would create tag: v2.0.0

./get-next-version.sh
Analyzing commits since v1.2.3...
Found: 2 feat, 5 fix, 0 breaking
Recommended bump: minor
Next version: 1.3.0
```

## Success Criteria

- Correct semver bumping
- Updates multiple files consistently
- Creates git commit and tag
- Dry-run mode works
- Conventional commit analysis
- Idempotent (safe to re-run)
