#!/usr/bin/env bash

set -uo pipefail

readonly DEFAULT_LOG_LINES=120

usage() {
    cat <<'EOF'
Usage: check_open_pr_ci.sh [--log-lines NUMBER]

Check CI for every open pull request authored by the authenticated GitHub user
in the repository configured as the current Git repository's "origin" remote.

Failed GitHub Actions checks include the tail of their failed-step logs. For
external checks, the script prints the check URL instead.

Options:
  --log-lines NUMBER  Lines of failed-step log to print per job (default: 120).
                      Use 0 to print the complete failed-step log.
  -h, --help          Show this help.

Exit status is 0 if every PR's CI passed (or there are no open PRs), 1 if at
least one PR has failed, pending, or missing CI, and 2 for a usage/tool error.
EOF
}

die() {
    printf 'error: %s\n' "$*" >&2
    exit 2
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

repo_from_remote() {
    local remote=$1
    local host path remainder

    if [[ $remote == *://* ]]; then
        remainder=${remote#*://}
        remainder=${remainder#*@}
        host=${remainder%%/*}
        path=${remainder#*/}
    elif [[ $remote =~ ^([^@/]+@)?([^:/]+):(.+)$ ]]; then
        host=${BASH_REMATCH[2]}
        path=${BASH_REMATCH[3]}
    else
        return 1
    fi

    host=${host%%:*}
    path=${path#/}
    path=${path%/}
    path=${path%.git}

    [[ -n $host && $path == */* ]] || return 1
    [[ $path != */*/* ]] || return 1

    if [[ $host == github.com ]]; then
        printf '%s\n' "$path"
    else
        printf '%s/%s\n' "$host" "$path"
    fi
}

indent() {
    sed 's/^/      /'
}

print_actions_logs() {
    local repo=$1
    local run_id=$2
    local job_id=$3
    local log_lines=$4
    local logs rc line_count

    if [[ -n $job_id ]]; then
        logs=$(gh run view "$run_id" --repo "$repo" --job "$job_id" --log-failed 2>&1)
    else
        logs=$(gh run view "$run_id" --repo "$repo" --log-failed 2>&1)
    fi
    rc=$?

    if ((rc != 0)); then
        printf '    Logs unavailable: %s\n' "${logs:-GitHub CLI returned status $rc}"
        return
    fi

    if [[ -z $logs ]]; then
        printf '    Logs unavailable: no failed-step log was returned.\n'
        return
    fi

    line_count=$(printf '%s\n' "$logs" | wc -l)
    if ((log_lines > 0 && line_count > log_lines)); then
        printf '    Logs (last %d of %d lines):\n' "$log_lines" "$line_count"
        printf '%s\n' "$logs" | tail -n "$log_lines" | indent
    else
        printf '    Logs:\n'
        printf '%s\n' "$logs" | indent
    fi
}

log_lines=$DEFAULT_LOG_LINES
while (($# > 0)); do
    case $1 in
        --log-lines)
            (($# >= 2)) || die '--log-lines requires a number'
            [[ $2 =~ ^[0-9]+$ ]] || die '--log-lines must be a non-negative integer'
            log_lines=$2
            shift 2
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            die "unknown argument: $1"
            ;;
    esac
done

require_command git
require_command gh
require_command jq

remote_url=$(git remote get-url origin 2>/dev/null) ||
    die 'could not read the origin remote; run this from a Git repository with an origin remote'
repo=$(repo_from_remote "$remote_url") ||
    die "origin is not a supported GitHub repository URL: $remote_url"

prs=$(gh pr list \
    --repo "$repo" \
    --author '@me' \
    --state open \
    --limit 1000 \
    --json number,title,url 2>&1)
rc=$?
((rc == 0)) || die "could not list pull requests for $repo: $prs"
jq -e 'type == "array"' >/dev/null 2>&1 <<<"$prs" || die 'GitHub CLI returned invalid pull-request data'

pr_count=$(jq 'length' <<<"$prs")
printf 'Repository: %s\n' "$repo"
printf 'Open pull requests authored by you: %d\n' "$pr_count"

if ((pr_count == 0)); then
    exit 0
fi

overall_status=0
while IFS= read -r pr; do
    number=$(jq -r '.number' <<<"$pr")
    title=$(jq -r '.title' <<<"$pr")
    url=$(jq -r '.url' <<<"$pr")

    checks=$(gh pr checks "$number" \
        --repo "$repo" \
        --json bucket,link,name,state,workflow 2>&1)
    checks_rc=$?

    if ! jq -e 'type == "array"' >/dev/null 2>&1 <<<"$checks"; then
        printf '\n? #%s %s\n  %s\n' "$number" "$title" "$url"
        printf '  Could not read CI checks: %s\n' "$checks"
        overall_status=1
        continue
    fi

    check_count=$(jq 'length' <<<"$checks")
    failed_count=$(jq '[.[] | select(.bucket == "fail" or .bucket == "cancel")] | length' <<<"$checks")
    pending_count=$(jq '[.[] | select(.bucket == "pending")] | length' <<<"$checks")

    if ((failed_count > 0)); then
        printf '\n✗ #%s %s\n  %s\n' "$number" "$title" "$url"
        overall_status=1

        while IFS= read -r check; do
            name=$(jq -r '.name' <<<"$check")
            workflow=$(jq -r '.workflow // empty' <<<"$check")
            state=$(jq -r '.state' <<<"$check")
            link=$(jq -r '.link // empty' <<<"$check")

            if [[ -n $workflow && $workflow != "$name" ]]; then
                printf '  Failed job: %s / %s (%s)\n' "$workflow" "$name" "$state"
            else
                printf '  Failed job: %s (%s)\n' "$name" "$state"
            fi
            [[ -z $link ]] || printf '    %s\n' "$link"

            if [[ $link =~ /actions/runs/([0-9]+)(/attempts/[0-9]+)?/job/([0-9]+) ]]; then
                print_actions_logs "$repo" "${BASH_REMATCH[1]}" "${BASH_REMATCH[3]}" "$log_lines"
            elif [[ $link =~ /actions/runs/([0-9]+) ]]; then
                print_actions_logs "$repo" "${BASH_REMATCH[1]}" '' "$log_lines"
            else
                printf '    Logs unavailable through GitHub Actions; use the check link above.\n'
            fi
        done < <(jq -c '.[] | select(.bucket == "fail" or .bucket == "cancel")' <<<"$checks")
    elif ((pending_count > 0)); then
        printf '\n… #%s %s\n  %s\n' "$number" "$title" "$url"
        printf '  CI is still pending (%d check(s)).\n' "$pending_count"
        overall_status=1
    elif ((check_count == 0)); then
        printf '\n? #%s %s\n  %s\n' "$number" "$title" "$url"
        printf '  No CI checks were found.\n'
        overall_status=1
    elif ((checks_rc != 0)); then
        # gh uses a non-zero status for failed or pending checks. Reaching this
        # branch means it returned an unexpected status despite valid JSON.
        printf '\n? #%s %s\n  %s\n' "$number" "$title" "$url"
        printf '  CI status could not be classified (gh exit status %d).\n' "$checks_rc"
        overall_status=1
    else
        printf '\n✓ #%s %s\n  %s\n  CI passed.\n' "$number" "$title" "$url"
    fi
done < <(jq -c '.[]' <<<"$prs")

exit "$overall_status"
