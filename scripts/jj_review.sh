#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: jj review [--update] [--remote REMOTE] <PR_NUMBER_OR_URL>

Create or update a local two-change review stack for a GitHub pull request:

    review_<PR>/accepted -> review_<PR>/todo

The todo change has the same tree as the pull request tip. Its diff contains
only changes not yet moved into accepted. Mark files or hunks as reviewed with:

    jj squash --from review_<PR>/todo --into review_<PR>/accepted --keep-emptied <paths>...
    jj squash --interactive --from review_<PR>/todo --into review_<PR>/accepted --keep-emptied

Options:
    -u, --update          Fetch and incorporate the latest PR version
    -r, --remote REMOTE   Git remote hosting the pull request (default: origin)
    -h, --help            Show this help
EOF
}

die() {
    printf 'jj review: %s\n' "$*" >&2
    exit 1
}

update=false
remote=origin
pr_arg=

while (($# > 0)); do
    case "$1" in
        -u|--update)
            update=true
            shift
            ;;
        -r|--remote)
            (($# >= 2)) || die "$1 requires a remote name"
            remote=$2
            shift 2
            ;;
        --remote=*)
            remote=${1#*=}
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            (($# == 1)) || die "expected exactly one PR number or URL after --"
            pr_arg=$1
            shift
            ;;
        -*)
            die "unknown option: $1"
            ;;
        *)
            [[ -z $pr_arg ]] || die "expected exactly one PR number or URL"
            pr_arg=$1
            shift
            ;;
    esac
done

[[ -n $pr_arg ]] || {
    usage >&2
    exit 2
}
[[ $remote =~ ^[A-Za-z0-9._-]+$ ]] || die "invalid remote name: $remote"

command -v gh >/dev/null || die "gh is required to look up GitHub pull requests"
command -v git >/dev/null || die "git is required to fetch GitHub pull refs"
command -v jj >/dev/null || die "jj is required"

workspace_root=${JJ_WORKSPACE_ROOT:-$(jj workspace root)}
cd "$workspace_root"

metadata=$(gh pr view "$pr_arg" \
    --json number,baseRefName,state,url \
    --jq '[.number, .baseRefName, .state, .url] | @tsv') \
    || die "could not look up pull request $pr_arg with gh"
IFS=$'\t' read -r pr_id base_ref state pr_url <<<"$metadata"

[[ $pr_id =~ ^[0-9]+$ ]] || die "gh returned an invalid PR number: $pr_id"
[[ -n $base_ref ]] || die "gh did not return the PR base branch"
git check-ref-format "refs/heads/$base_ref" >/dev/null \
    || die "gh returned an invalid base branch: $base_ref"

accepted_bookmark="review_${pr_id}/accepted"
todo_bookmark="review_${pr_id}/todo"
pull_ref="refs/remotes/${remote}/pull/${pr_id}"
base_ref_remote="refs/remotes/${remote}/${base_ref}"
git_dir=$(jj git root)

printf 'Fetching PR #%s (%s, %s) from %s...\n' "$pr_id" "$state" "$pr_url" "$remote"
git --git-dir="$git_dir" fetch "$remote" \
    "+refs/heads/${base_ref}:${base_ref_remote}" \
    "+refs/pull/${pr_id}/head:${pull_ref}"
jj git import

tip_oid=$(git --git-dir="$git_dir" rev-parse --verify "${pull_ref}^{commit}")
base_oid=$(git --git-dir="$git_dir" rev-parse --verify "${base_ref_remote}^{commit}")
merge_base=$(jj log \
    -r "fork_point(commit_id(${tip_oid}) | commit_id(${base_oid}))" \
    --no-graph -T 'commit_id ++ "\n"')
[[ $merge_base =~ ^[0-9a-f]{40}$ ]] \
    || die "could not determine a unique merge base for PR #$pr_id"

bookmark_commit() {
    local name=$1
    jj log -r "bookmarks(exact:\"${name}\")" --no-graph -T 'commit_id ++ "\n"'
}

accepted_commit=$(bookmark_commit "$accepted_bookmark")
todo_commit=$(bookmark_commit "$todo_bookmark")

if [[ $update == false ]]; then
    if [[ -n $accepted_commit || -n $todo_commit ]]; then
        die "review bookmarks already exist; run 'jj review --update $pr_id'"
    fi

    jj new "$merge_base" -m "review #${pr_id}: todo"
    jj restore --from "$tip_oid"
    jj new --no-edit --insert-before @ -m "review #${pr_id}: accepted"
    jj bookmark create "$accepted_bookmark" -r @-
    jj bookmark create "$todo_bookmark" -r @
else
    if [[ -z $accepted_commit && -z $todo_commit ]]; then
        die "review bookmarks do not exist; run 'jj review $pr_id' first"
    fi
    if [[ -z $accepted_commit || -z $todo_commit ]]; then
        die "review stack is incomplete; expected both $accepted_bookmark and $todo_bookmark"
    fi

    accepted_is_parent=$(jj log \
        -r "parents(commit_id(${todo_commit})) & commit_id(${accepted_commit})" \
        --no-graph -T 'commit_id ++ "\n"')
    [[ $accepted_is_parent == "$accepted_commit" ]] \
        || die "$accepted_bookmark is no longer the direct parent of $todo_bookmark"

    jj rebase \
        -r "commit_id(${accepted_commit}) | commit_id(${todo_commit})" \
        -o "$merge_base"
    jj restore --from "$tip_oid" --into "$todo_bookmark"
    jj edit "$todo_bookmark"
fi

printf '\nReview stack for PR #%s:\n' "$pr_id"
jj log -r "${accepted_bookmark}::${todo_bookmark}"
printf '\nRemaining to review:\n'
jj diff -r "$todo_bookmark" --stat

