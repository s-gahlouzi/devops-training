#!/usr/bin/env bash

# GitHub Actions utility functions

# Set output
gh_output() {
    local key="$1"
    local value="$2"
    echo "${key}=${value}" >> "${GITHUB_OUTPUT:-/dev/null}"
}

# Add to summary
gh_summary() {
    echo "$*" >> "${GITHUB_STEP_SUMMARY:-/dev/null}"
}

# Annotations
gh_error() {
    local message="$1"
    local file="${2:-}"
    local line="${3:-}"
    
    local annotation="::error"
    [[ -n "$file" ]] && annotation="${annotation} file=${file}"
    [[ -n "$line" ]] && annotation="${annotation},line=${line}"
    echo "${annotation}::${message}"
}

gh_warning() {
    local message="$1"
    local file="${2:-}"
    local line="${3:-}"
    
    local annotation="::warning"
    [[ -n "$file" ]] && annotation="${annotation} file=${file}"
    [[ -n "$line" ]] && annotation="${annotation},line=${line}"
    echo "${annotation}::${message}"
}

gh_notice() {
    echo "::notice::$1"
}

# Log groups
gh_group() {
    local title="$1"
    shift
    
    echo "::group::${title}"
    "$@"
    local exit_code=$?
    echo "::endgroup::"
    
    return $exit_code
}

# Environment
gh_set_env() {
    local key="$1"
    local value="$2"
    echo "${key}=${value}" >> "${GITHUB_ENV:-/dev/null}"
}

gh_add_path() {
    echo "$1" >> "${GITHUB_PATH:-/dev/null}"
}

gh_mask() {
    echo "::add-mask::$1"
}

# CI detection
is_ci() {
    [[ "${CI:-false}" == "true" ]]
}

is_github_actions() {
    [[ -n "${GITHUB_ACTIONS:-}" ]]
}

is_pull_request() {
    [[ "${GITHUB_EVENT_NAME:-}" == "pull_request" ]]
}

# Context
get_pr_number() {
    if [[ -f "${GITHUB_EVENT_PATH:-}" ]]; then
        jq -r '.pull_request.number // empty' "$GITHUB_EVENT_PATH"
    fi
}

get_branch_name() {
    echo "${GITHUB_REF_NAME:-}"
}

get_commit_sha() {
    echo "${GITHUB_SHA:-}"
}

get_short_sha() {
    echo "${GITHUB_SHA:0:7}"
}

get_repository() {
    echo "${GITHUB_REPOSITORY:-}"
}

get_actor() {
    echo "${GITHUB_ACTOR:-}"
}
