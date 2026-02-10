# Bash for DevOps & CI/CD

A practice-first learning path for mastering Bash scripting in DevOps and CI/CD contexts.

## How to Use This Course

1. **Read** `docs.md` - Your comprehensive reference guide
2. **Practice** - Work through exercises in order
3. **Check** solutions only after attempting
4. **Apply** - Use patterns in real projects

## Learning Path

### Fundamentals (Ex 1-8)

Essential bash concepts and syntax.

- **01-variables-quoting** - Variables, quoting rules, command substitution
- **02-exit-codes** - Exit codes and error handling
- **03-conditionals-if** - if/else statements and test operators
- **04-case-statements** - Pattern matching with case
- **05-for-loops** - Iteration over lists and files
- **06-while-loops** - While/until loops and file reading
- **07-functions** - Function definition, arguments, returns
- **08-string-operations** - Parameter expansion and string manipulation

### Data Structures (Ex 9-10)

Working with arrays and maps.

- **09-indexed-arrays** - Array operations and iteration
- **10-associative-arrays** - Hash maps for configuration

### File & I/O (Ex 11-12)

File operations and stream handling.

- **11-file-operations** - File tests, permissions, operations
- **12-io-redirection** - Stdin/stdout/stderr, pipes, here-docs

### Text Processing (Ex 13-17)

Essential text processing tools.

- **13-grep-patterns** - Search and pattern matching
- **14-sed-transformations** - Stream editing and replacement
- **15-awk-processing** - Column-based data processing
- **16-jq-json** - JSON parsing and manipulation
- **17-yq-yaml** - YAML processing for configs

### Production-Ready (Ex 18-21)

Writing safe, reliable scripts.

- **18-set-options-pipefail** - Safe script options (set -euo pipefail)
- **19-traps-cleanup** - Resource cleanup and signal handling
- **20-debugging-shellcheck** - Debugging techniques and static analysis
- **21-process-management** - Background jobs, parallelism, timeouts

### CI/CD Practical (Ex 22-25)

Real-world DevOps automation with GitHub Actions.

- **22-cicd-build-script** - Production build automation
- **23-docker-entrypoint** - Container initialization scripts
- **24-version-bumping** - Semantic versioning automation
- **25-github-actions-helper** - GitHub Actions utility functions

## Exercise Structure

Each exercise contains:

```
exercises/XX-topic/
├── requirement.md  # What to build
└── theory.md       # Concepts and patterns

solutions/XX-topic/
└── (solution files)
```

## Best Practices

Always include in production scripts:

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

## Quick Reference

### Safe Script Template

```bash
#!/usr/bin/env bash
set -euo pipefail

cleanup() {
    # Cleanup code
}
trap cleanup EXIT

main() {
    # Main logic
}

main "$@"
```

### CI/CD Script Template

```bash
#!/usr/bin/env bash
set -euo pipefail

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

validate_environment() {
    : "${VAR:?VAR is required}"
}

main() {
    log "Starting..."
    validate_environment
    # Main logic
}

main "$@"
```

## Tips for Success

1. **Write code first** - Try exercises before looking at solutions
2. **Run shellcheck** - Use `shellcheck script.sh` to catch issues
3. **Test thoroughly** - Try edge cases and error conditions
4. **Read real code** - Study scripts from popular projects
5. **Build real tools** - Apply learning to actual automation tasks

## Additional Resources

- [ShellCheck](https://www.shellcheck.net/) - Online linter
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

## Progress Tracking

- [ ] Fundamentals (1-8)
- [ ] Data Structures (9-10)
- [ ] File & I/O (11-12)
- [ ] Text Processing (13-17)
- [ ] Production-Ready (18-21)
- [ ] CI/CD Practical (22-25)

## What's Next?

After completing this course:

1. Apply patterns to your CI/CD pipelines
2. Automate deployment workflows
3. Create reusable script libraries
4. Contribute to open source DevOps tools
5. Write GitHub Actions with custom scripts

Happy learning! 🚀
