#!/usr/bin/env bash

set -Eeuo pipefail

readonly PROGRAM_NAME="${0##*/}"

declare -a REQUIRED_COMMANDS=(curl jq fzf)
declare -a COLUMN_KEYS=(backlog selected_for_development in_progress review packaging "done")

JIRA_CONFIG_FILE="${JIRA_CONFIG_FILE:-${XDG_CONFIG_HOME:-${HOME:-}/.config}/jira/config.json}"

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

cancel() {
    printf 'Cancelled.\n' >&2
    exit 130
}

config_value() {
    local query=$1

    [[ -f "$JIRA_CONFIG_FILE" ]] || return 0
    jq -er "$query // empty" "$JIRA_CONFIG_FILE" 2>/dev/null || true
}

load_config() {
    if [[ -f "$JIRA_CONFIG_FILE" ]] && ! jq -e . "$JIRA_CONFIG_FILE" >/dev/null 2>&1; then
        die "invalid JSON in $JIRA_CONFIG_FILE"
    fi

    JIRA_URL="${JIRA_URL:-$(config_value '.url')}"
    JIRA_API_TOKEN="${JIRA_API_TOKEN:-$(config_value '.api_token')}"
    JIRA_PROJECT="${JIRA_PROJECT:-$(config_value '.project')}"
    JIRA_API_VERSION="${JIRA_API_VERSION:-$(config_value '.api_version')}"
    JIRA_STORY_POINTS_FIELD="${JIRA_STORY_POINTS_FIELD:-$(config_value '.story_points_field')}"
    JIRA_SEARCH_JQL="${JIRA_SEARCH_JQL:-$(config_value '.search_jql')}"
    JIRA_SEARCH_MAX_RESULTS="${JIRA_SEARCH_MAX_RESULTS:-$(config_value '.search_max_results')}"
    JIRA_MAINTENANCE_LABEL="${JIRA_MAINTENANCE_LABEL:-$(config_value '.maintenance_label')}"
    JIRA_STORY_POINTS_REQUIRED_SINCE="${JIRA_STORY_POINTS_REQUIRED_SINCE:-$(config_value '.story_points_required_since')}"
    JIRA_STATUS_BACKLOG="${JIRA_STATUS_BACKLOG:-$(config_value '.statuses.backlog')}"
    JIRA_STATUS_SELECTED_FOR_DEVELOPMENT="${JIRA_STATUS_SELECTED_FOR_DEVELOPMENT:-$(config_value '.statuses.selected_for_development')}"
    JIRA_STATUS_IN_PROGRESS="${JIRA_STATUS_IN_PROGRESS:-$(config_value '.statuses.in_progress')}"
    JIRA_STATUS_REVIEW="${JIRA_STATUS_REVIEW:-$(config_value '.statuses.review')}"
    JIRA_STATUS_PACKAGING="${JIRA_STATUS_PACKAGING:-$(config_value '.statuses.packaging')}"
    JIRA_STATUS_DONE="${JIRA_STATUS_DONE:-$(config_value '.statuses.done')}"
    GITHUB_ORG="${GITHUB_ORG:-$(config_value '.github_org')}"
    GITHUB_API_URL="${GITHUB_API_URL:-$(config_value '.github_api_url')}"
    GITHUB_TOKEN="${GITHUB_TOKEN:-$(config_value '.github_token')}"

    JIRA_URL="${JIRA_URL%/}"
    JIRA_API_VERSION="${JIRA_API_VERSION:-2}"
    JIRA_API_PATH="/rest/api/$JIRA_API_VERSION"
    JIRA_SEARCH_JQL="${JIRA_SEARCH_JQL:-(creator = currentUser() OR assignee = currentUser()) ORDER BY updated DESC}"
    JIRA_SEARCH_MAX_RESULTS="${JIRA_SEARCH_MAX_RESULTS:-100}"
    JIRA_MAINTENANCE_LABEL="${JIRA_MAINTENANCE_LABEL:-Maintenance}"
    JIRA_STORY_POINTS_REQUIRED_SINCE="${JIRA_STORY_POINTS_REQUIRED_SINCE:-2026-08-05}"
    JIRA_STATUS_BACKLOG="${JIRA_STATUS_BACKLOG:-Backlog}"
    JIRA_STATUS_SELECTED_FOR_DEVELOPMENT="${JIRA_STATUS_SELECTED_FOR_DEVELOPMENT:-Selected for Development}"
    JIRA_STATUS_IN_PROGRESS="${JIRA_STATUS_IN_PROGRESS:-In Progress}"
    JIRA_STATUS_REVIEW="${JIRA_STATUS_REVIEW:-Review}"
    JIRA_STATUS_PACKAGING="${JIRA_STATUS_PACKAGING:-Packaging}"
    JIRA_STATUS_DONE="${JIRA_STATUS_DONE:-Done}"
    GITHUB_ORG="${GITHUB_ORG:-greenbone}"
    GITHUB_API_URL="${GITHUB_API_URL:-https://api.github.com}"
    GITHUB_API_URL="${GITHUB_API_URL%/}"
}

print_config_example() {
    cat >&2 <<'EOF'
Create ~/.config/jira/config.json (and chmod 600 it):

{
  "url": "test.com",
  "api_token": "your-jira-personal-access-token",
  "project": "PROJ"
}

Every setting can instead be supplied as an environment variable. Optional
config keys are api_version, story_points_field, story_points_required_since,
maintenance_label, search_jql, search_max_results, github_org, github_api_url,
github_token, and
statuses.{backlog,selected_for_development,in_progress,review,packaging,done}.
EOF
}

require_commands() {
    local command_name

    for command_name in "${REQUIRED_COMMANDS[@]}"; do
        command -v "$command_name" >/dev/null 2>&1 || die "required command not found: $command_name"
    done
}

require_config() {
    local -a missing=()
    local variable

    for variable in JIRA_URL JIRA_API_TOKEN JIRA_PROJECT; do
        [[ -n "${!variable:-}" ]] || missing+=("$variable")
    done

    if ((${#missing[@]})); then
        printf 'Missing configuration: %s\n\n' "${missing[*]}" >&2
        print_config_example
        exit 1
    fi

    [[ "$JIRA_URL" == http://* || "$JIRA_URL" == https://* ]] || die "JIRA_URL must start with http:// or https://"
    [[ "$JIRA_API_VERSION" == 2 || "$JIRA_API_VERSION" == latest ]] || die "JIRA_API_VERSION must be 2 or latest"
    [[ "$JIRA_SEARCH_MAX_RESULTS" =~ ^[1-9][0-9]*$ ]] || die "JIRA_SEARCH_MAX_RESULTS must be a positive integer"
    [[ "$JIRA_STORY_POINTS_REQUIRED_SINCE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || \
        die "JIRA_STORY_POINTS_REQUIRED_SINCE must use YYYY-MM-DD format"
}

api_error_message() {
    local response_file=$1
    local message

    message=$(jq -r '
        [
            .errorMessages[]?,
            ((.errors // {}) | to_entries[]? | "\(.key): \(.value)"),
            .message?
        ]
        | map(select(. != null and . != ""))
        | join("; ")
    ' "$response_file" 2>/dev/null || true)

    if [[ -n "$message" ]]; then
        printf '%s' "$message"
    elif [[ -s "$response_file" ]]; then
        tr '\n' ' ' <"$response_file"
    else
        printf 'Jira returned an empty response'
    fi
}

jira_request() {
    local method=$1
    local path=$2
    local body=${3-}
    local response_file http_code
    local -a curl_args

    response_file=$(mktemp "${TMPDIR:-/tmp}/jira-response.XXXXXX")
    curl_args=(
        --silent
        --show-error
        --request "$method"
        --header 'Accept: application/json'
        --output "$response_file"
        --write-out '%{http_code}'
    )

    if [[ -n "$body" ]]; then
        curl_args+=(--header 'Content-Type: application/json' --data-binary @-)
        if ! http_code=$(curl \
            --config <(printf 'header = "Authorization: Bearer %s"\n' "$JIRA_API_TOKEN") \
            "${curl_args[@]}" "$JIRA_URL$path" <<<"$body"); then
            rm -f -- "$response_file"
            die "could not connect to Jira at $JIRA_URL"
        fi
    elif ! http_code=$(curl \
        --config <(printf 'header = "Authorization: Bearer %s"\n' "$JIRA_API_TOKEN") \
        "${curl_args[@]}" "$JIRA_URL$path"); then
        rm -f -- "$response_file"
        die "could not connect to Jira at $JIRA_URL"
    fi

    if [[ ! "$http_code" =~ ^2 ]]; then
        local error_message
        error_message=$(api_error_message "$response_file")
        rm -f -- "$response_file"
        die "Jira API $method $path failed (HTTP $http_code): $error_message"
    fi

    cat "$response_file"
    rm -f -- "$response_file"
}

github_search_pull_requests() {
    local query=$1
    local response_file http_code error_message
    local -a curl_args

    response_file=$(mktemp "${TMPDIR:-/tmp}/github-response.XXXXXX")
    curl_args=(
        --silent
        --show-error
        --get
        --header 'Accept: application/vnd.github+json'
        --header 'X-GitHub-Api-Version: 2022-11-28'
        --data-urlencode "q=$query"
        --data-urlencode 'per_page=100'
        --output "$response_file"
        --write-out '%{http_code}'
    )

    if [[ -n "$GITHUB_TOKEN" ]]; then
        if ! http_code=$(curl \
            --config <(printf 'header = "Authorization: Bearer %s"\n' "$GITHUB_TOKEN") \
            "${curl_args[@]}" "$GITHUB_API_URL/search/issues"); then
            rm -f -- "$response_file"
            die "could not connect to GitHub at $GITHUB_API_URL"
        fi
    elif ! http_code=$(curl "${curl_args[@]}" "$GITHUB_API_URL/search/issues"); then
        rm -f -- "$response_file"
        die "could not connect to GitHub at $GITHUB_API_URL"
    fi

    if [[ ! "$http_code" =~ ^2 ]]; then
        error_message=$(jq -r '.message // empty' "$response_file" 2>/dev/null || true)
        [[ -n "$error_message" ]] || error_message="GitHub returned HTTP $http_code"
        rm -f -- "$response_file"
        die "GitHub PR search failed (HTTP $http_code): $error_message"
    fi

    cat "$response_file"
    rm -f -- "$response_file"
}

choose() {
    local prompt=$1
    shift
    local selection

    selection=$(printf '%s\n' "$@" | fzf \
        --height=40% \
        --layout=reverse \
        --border \
        --no-multi \
        --prompt="$prompt > ") || cancel
    [[ -n "$selection" ]] || cancel
    printf '%s' "$selection"
}

prompt_required() {
    local prompt=$1
    local value

    while true; do
        read -r -e -p "$prompt: " value || cancel
        [[ -n "$value" ]] && break
        printf '%s is required.\n' "$prompt" >&2
    done
    printf '%s' "$value"
}

prompt_optional() {
    local prompt=$1
    local value

    read -r -e -p "$prompt: " value || cancel
    printf '%s' "$value"
}

column_label() {
    case $1 in
        backlog) printf 'Backlog' ;;
        selected_for_development) printf 'Selected for Development' ;;
        in_progress) printf 'In Progress' ;;
        review) printf 'Review' ;;
        packaging) printf 'Packaging' ;;
        done) printf 'Done' ;;
        *) die "unknown column: $1" ;;
    esac
}

status_for_column() {
    case $1 in
        backlog) printf '%s' "$JIRA_STATUS_BACKLOG" ;;
        selected_for_development) printf '%s' "$JIRA_STATUS_SELECTED_FOR_DEVELOPMENT" ;;
        in_progress) printf '%s' "$JIRA_STATUS_IN_PROGRESS" ;;
        review) printf '%s' "$JIRA_STATUS_REVIEW" ;;
        packaging) printf '%s' "$JIRA_STATUS_PACKAGING" ;;
        done) printf '%s' "$JIRA_STATUS_DONE" ;;
        *) die "unknown column: $1" ;;
    esac
}

column_from_label() {
    case $1 in
        Backlog) printf 'backlog' ;;
        'Selected for Development') printf 'selected_for_development' ;;
        'In Progress') printf 'in_progress' ;;
        Review) printf 'review' ;;
        Packaging) printf 'packaging' ;;
        Done) printf 'done' ;;
        *) die "unknown column label: $1" ;;
    esac
}

choose_column() {
    local -a labels=()
    local key label

    for key in "${COLUMN_KEYS[@]}"; do
        labels+=("$(column_label "$key")")
    done
    label=$(choose 'Column' "${labels[@]}")
    column_from_label "$label"
}

normalize_status() {
    tr '[:upper:]' '[:lower:]' <<<"$1" | tr -cd '[:alnum:]'
}

issue_status() {
    local issue_key=$1
    jira_request GET "$JIRA_API_PATH/issue/$issue_key?fields=status" | jq -er '.fields.status.name'
}

get_transitions() {
    local issue_key=$1
    jira_request GET "$JIRA_API_PATH/issue/$issue_key/transitions?expand=transitions.fields"
}

resolve_fix_versions() {
    local issue_key=$1
    local issue project_key existing versions rows selection version_id

    issue=$(jira_request GET "$JIRA_API_PATH/issue/$issue_key?fields=project,fixVersions")
    project_key=$(jq -er '.fields.project.key' <<<"$issue")
    existing=$(jq -c '[.fields.fixVersions[]? | {id: (.id | tostring)}]' <<<"$issue")
    if [[ "$existing" != '[]' ]]; then
        printf '%s' "$existing"
        return 0
    fi

    versions=$(jira_request GET "$JIRA_API_PATH/project/$project_key/versions")
    rows=$(jq -r '
        [
            .[]
            | select(.archived != true)
        ]
        | sort_by(.released, .releaseDate // "9999-99-99", .name)
        | .[]
        | [
            (.id | tostring),
            .name,
            (if .released then "released" else "unreleased" end),
            (.releaseDate // "-")
        ]
        | @tsv
    ' <<<"$versions")
    [[ -n "$rows" ]] || die "the $project_key project has no non-archived fix versions"

    selection=$(fzf \
        --height=60% \
        --layout=reverse \
        --border \
        --no-multi \
        --delimiter=$'\t' \
        --with-nth=2.. \
        --header=$'VERSION\tSTATE\tRELEASE DATE' \
        --prompt='Fix version > ' \
        <<<"$rows") || cancel
    [[ -n "$selection" ]] || cancel
    version_id=${selection%%$'\t'*}
    jq -cn --arg id "$version_id" '[{id: $id}]'
}

resolve_resolution() {
    local transition=$1
    local resolution_id rows selection

    resolution_id=$(jq -r '
        [
            .fields.resolution.allowedValues[]?
            | select((.name | ascii_downcase) == "done")
        ][0].id // empty
    ' <<<"$transition")
    if [[ -n "$resolution_id" ]]; then
        printf '%s' "$resolution_id"
        return 0
    fi

    rows=$(jq -r '
        .fields.resolution.allowedValues[]?
        | [(.id | tostring), .name]
        | @tsv
    ' <<<"$transition")
    [[ -n "$rows" ]] || die "the transition requires a resolution but Jira returned no allowed values"

    selection=$(fzf \
        --height=40% \
        --layout=reverse \
        --border \
        --no-multi \
        --delimiter=$'\t' \
        --with-nth=2 \
        --header='RESOLUTION' \
        --prompt='Resolution > ' \
        <<<"$rows") || cancel
    [[ -n "$selection" ]] || cancel
    printf '%s' "${selection%%$'\t'*}"
}

try_transition_to_status() {
    local issue_key=$1
    local target_status=$2
    local transitions transition transition_id payload fix_versions resolution_id
    local normalized_target

    transitions=$(get_transitions "$issue_key")
    normalized_target=$(normalize_status "$target_status")
    transition=$(jq -c --arg target "$normalized_target" '
        def normalize: ascii_downcase | gsub("[^a-z0-9]"; "");
        [
            .transitions[]
            | select((.to.name | normalize) == $target or (.name | normalize) == $target)
        ][0] // empty
    ' <<<"$transitions")

    [[ -n "$transition" ]] || return 1
    transition_id=$(jq -r '.id' <<<"$transition")
    payload=$(jq -n --arg id "$transition_id" '{transition: {id: $id}}')

    # Greenbone's Packaging transition has a hidden Fix Version/s validator,
    # but Jira does not expose the field in that transition's metadata. Set it
    # on the issue first. Done exposes the field too, but must not prompt for it.
    if [[ $(normalize_status "$target_status") == $(normalize_status "$JIRA_STATUS_PACKAGING") ]]; then
        fix_versions=$(resolve_fix_versions "$issue_key")
        jira_request PUT "$JIRA_API_PATH/issue/$issue_key" \
            "$(jq -cn --argjson fix_versions "$fix_versions" \
                '{fields: {fixVersions: $fix_versions}}')" >/dev/null
    fi

    if [[ $(jq -r '.fields.resolution.required // false' <<<"$transition") == true ]]; then
        resolution_id=$(resolve_resolution "$transition")
        payload=$(jq --arg resolution_id "$resolution_id" \
            '.fields.resolution = {id: $resolution_id}' <<<"$payload")
    fi

    jira_request POST "$JIRA_API_PATH/issue/$issue_key/transitions" "$payload" >/dev/null
}

column_index_for_status() {
    local wanted
    local index status

    wanted=$(normalize_status "$1")
    for index in "${!COLUMN_KEYS[@]}"; do
        status=$(status_for_column "${COLUMN_KEYS[$index]}")
        if [[ $(normalize_status "$status") == "$wanted" ]]; then
            printf '%s' "$index"
            return 0
        fi
    done
    return 1
}

move_issue() {
    local issue_key=$1
    local target_column=$2
    local target_status current_status current_index target_index next_index next_status direction
    local transitions available

    target_status=$(status_for_column "$target_column")
    current_status=$(issue_status "$issue_key")

    if [[ $(normalize_status "$current_status") == $(normalize_status "$target_status") ]]; then
        printf '%s is already in %s.\n' "$issue_key" "$(column_label "$target_column")"
        return 0
    fi

    if try_transition_to_status "$issue_key" "$target_status"; then
        printf 'Moved %s: %s -> %s\n' "$issue_key" "$current_status" "$target_status"
        return 0
    fi

    if ! current_index=$(column_index_for_status "$current_status"); then
        transitions=$(get_transitions "$issue_key")
        available=$(jq -r '[.transitions[].to.name] | unique | join(", ")' <<<"$transitions")
        die "cannot map current status '$current_status' to a configured column. Available destinations: ${available:-none}"
    fi
    target_index=$(column_index_for_status "$target_status")

    ((target_index > current_index)) && direction=1 || direction=-1
    next_index=$((current_index + direction))
    while ((next_index != target_index + direction)); do
        next_status=$(status_for_column "${COLUMN_KEYS[$next_index]}")
        if ! try_transition_to_status "$issue_key" "$next_status"; then
            transitions=$(get_transitions "$issue_key")
            available=$(jq -r '[.transitions[].to.name] | unique | join(", ")' <<<"$transitions")
            die "cannot move $issue_key from '$current_status' to '$next_status'. Available destinations: ${available:-none}"
        fi
        printf 'Moved %s: %s -> %s\n' "$issue_key" "$current_status" "$next_status"
        current_status=$next_status
        next_index=$((next_index + direction))
    done
}

discover_story_points_field() {
    local fields field_id

    fields=$(jira_request GET "$JIRA_API_PATH/field")
    field_id=$(jq -r '
        [
            .[]
            | select(
                (.name | ascii_downcase) == "story points"
                or (.name | ascii_downcase) == "story point estimate"
                or .schema.custom == "com.pyxis.greenhopper.jira:jsw-story-points"
            )
        ][0].id // empty
    ' <<<"$fields")
    [[ -n "$field_id" ]] || die "could not discover the story-points field; set story_points_field in $JIRA_CONFIG_FILE"
    printf '%s' "$field_id"
}

create_issue() {
    local issue_type summary description maintenance_choice points target_column
    local story_points_field payload response issue_key

    issue_type=$(choose 'Issue type' Task Bug Story)
    summary=$(prompt_required 'Summary')
    description=$(prompt_optional 'Description (optional)')
    maintenance_choice=$(choose "Add '$JIRA_MAINTENANCE_LABEL' label?" Yes No)

    while true; do
        points=$(prompt_optional 'Story points (blank to leave unset)')
        [[ -z "$points" || "$points" =~ ^[0-9]+([.][0-9]+)?$ ]] && break
        printf 'Story points must be a non-negative number.\n' >&2
    done

    target_column=$(choose_column)
    story_points_field=$JIRA_STORY_POINTS_FIELD
    if [[ -n "$points" && -z "$story_points_field" ]]; then
        story_points_field=$(discover_story_points_field)
    fi

    payload=$(jq -n \
        --arg project "$JIRA_PROJECT" \
        --arg issue_type "$issue_type" \
        --arg summary "$summary" \
        --arg description "$description" \
        --arg maintenance_choice "$maintenance_choice" \
        --arg maintenance_label "$JIRA_MAINTENANCE_LABEL" \
        --arg points "$points" \
        --arg story_points_field "$story_points_field" '
        {
            fields: {
                project: {key: $project},
                issuetype: {name: $issue_type},
                summary: $summary
            }
        }
        | if $description != "" then
            .fields.description = $description
          else . end
        | if $maintenance_choice == "Yes" then
            .fields.labels = [$maintenance_label]
          else . end
        | if $points != "" then
            .fields[$story_points_field] = ($points | tonumber)
          else . end
    ')

    response=$(jira_request POST "$JIRA_API_PATH/issue" "$payload")
    issue_key=$(jq -er '.key' <<<"$response")
    printf 'Created %s: %s/browse/%s\n' "$issue_key" "$JIRA_URL" "$issue_key"
    move_issue "$issue_key" "$target_column"
}

scoped_search_jql() {
    local include_done=${1:-false}
    local search_jql=$JIRA_SEARCH_JQL

    if [[ "$include_done" != true ]]; then
        search_jql=$(jq -nr --arg jql "$search_jql" '
            (($jql | capture(
                "^(?<query>.*?)(?<order>[[:space:]]+ORDER[[:space:]]+BY[[:space:]].*)$";
                "i"
            )?) // null) as $parts
            | if $parts == null then
                "(\($jql)) AND statusCategory != Done"
              else
                "(\($parts.query)) AND statusCategory != Done\($parts.order)"
              end
        ')
    fi
    printf '%s' "$search_jql"
}

search_all_jira_issues() {
    local search_jql=$1
    local fields=$2
    local start_at=0 total=0 count payload response page_issues
    local issues='[]'

    while true; do
        payload=$(jq -cn \
            --arg jql "$search_jql" \
            --argjson start_at "$start_at" \
            --argjson max_results "$JIRA_SEARCH_MAX_RESULTS" \
            --argjson fields "$fields" '
            {
                jql: $jql,
                startAt: $start_at,
                maxResults: $max_results,
                fields: $fields
            }
        ')
        response=$(jira_request POST "$JIRA_API_PATH/search" "$payload")
        page_issues=$(jq -c '.issues // []' <<<"$response")
        count=$(jq 'length' <<<"$page_issues")
        total=$(jq -r '.total // 0' <<<"$response")
        issues=$(jq -cn \
            --argjson existing "$issues" \
            --argjson page "$page_issues" \
            '$existing + $page')
        start_at=$((start_at + count))
        ((count > 0 && start_at < total)) || break
    done

    jq -cn --argjson total "$total" --argjson issues "$issues" \
        '{total: $total, issues: $issues}'
}

change_issue() {
    local include_done=${1:-false}
    local search_jql payload response rows selection issue_key target_column

    search_jql=$(scoped_search_jql "$include_done")

    payload=$(jq -n \
        --arg jql "$search_jql" \
        --argjson max_results "$JIRA_SEARCH_MAX_RESULTS" '
        {
            jql: $jql,
            maxResults: $max_results,
            fields: ["summary", "status", "issuetype", "assignee", "updated"]
        }
    ')
    response=$(jira_request POST "$JIRA_API_PATH/search" "$payload")
    rows=$(jq -r \
        --arg backlog "$JIRA_STATUS_BACKLOG" \
        --arg selected_for_development "$JIRA_STATUS_SELECTED_FOR_DEVELOPMENT" \
        --arg in_progress "$JIRA_STATUS_IN_PROGRESS" \
        --arg review "$JIRA_STATUS_REVIEW" \
        --arg packaging "$JIRA_STATUS_PACKAGING" \
        --arg 'done' "$JIRA_STATUS_DONE" '
        def normalize: ascii_downcase | gsub("[^a-z0-9]"; "");
        def pad($width):
            . as $value
            | $value + (" " * ([($width - ($value | length)), 0] | max));
        def short_status:
            . as $status
            | ($status | normalize) as $normalized
            | if $normalized == ($backlog | normalize) then "backlog"
              elif $normalized == ($selected_for_development | normalize) then "dev"
              elif $normalized == ($in_progress | normalize) then "progress"
              elif $normalized == ($review | normalize) then "review"
              elif $normalized == ($packaging | normalize) then "packaging"
              elif $normalized == ($done | normalize) then "done"
              elif $normalized == "onstaging" then "staging"
              else ($status | ascii_downcase)
              end;
        def short_type:
            ascii_downcase
            | if . == "improvement" then "improv"
              elif . == "external feedback" then "feedback"
              else .
              end;

        .issues[]
        | [
            (.key | pad(12)),
            (.fields.status.name | short_status | pad(9)),
            (.fields.issuetype.name | short_type | pad(8)),
            ((if .fields.assignee == null then "unassigned" else "me" end) | pad(10)),
            (.fields.summary | gsub("[\\t\\r\\n]"; " "))
        ]
        | join("  ")
    ' <<<"$response")
    [[ -n "$rows" ]] || die "no issues matched: $search_jql"

    selection=$(fzf \
        --height=70% \
        --layout=reverse \
        --border \
        --no-multi \
        --header='KEY           STATUS     TYPE      ASSIGNEE    SUMMARY' \
        --prompt='Issue > ' \
        <<<"$rows") || cancel
    [[ -n "$selection" ]] || cancel
    issue_key=${selection%% *}

    target_column=$(choose_column)
    move_issue "$issue_key" "$target_column"
    printf '%s/browse/%s\n' "$JIRA_URL" "$issue_key"
}

check_issues() {
    local search_jql story_points_field fields response issue_count
    local review_issues review_count review_keys_json pull_requests='[]'
    local github_response github_items query matches merged_urls key
    local index batch_end
    local -a review_keys=()
    local -a errors=()

    search_jql=$(scoped_search_jql false)
    story_points_field=$JIRA_STORY_POINTS_FIELD
    [[ -n "$story_points_field" ]] || story_points_field=$(discover_story_points_field)
    fields=$(jq -cn --arg story_points "$story_points_field" \
        '["status", "labels", "timespent", "created", $story_points]')
    response=$(search_all_jira_issues "$search_jql" "$fields")
    issue_count=$(jq '.issues | length' <<<"$response")
    printf 'Checking %s Jira issue(s) from the default change scope...\n' "$issue_count"

    review_issues=$(jq -c --arg review "$JIRA_STATUS_REVIEW" '
        def normalize: ascii_downcase | gsub("[^a-z0-9]"; "");
        [.issues[] | select((.fields.status.name | normalize) == ($review | normalize))]
    ' <<<"$response")
    review_count=$(jq 'length' <<<"$review_issues")
    mapfile -t review_keys < <(jq -r '.[].key' <<<"$review_issues")
    review_keys_json=$(printf '%s\n' "${review_keys[@]}" | jq -Rsc \
        'split("\n") | map(select(length > 0))')

    for ((index = 0; index < review_count; index += 6)); do
        batch_end=$((index + 6))
        ((batch_end > review_count)) && batch_end=$review_count
        query="org:$GITHUB_ORG is:pr in:title,body "
        for ((batch_index = index; batch_index < batch_end; batch_index++)); do
            ((batch_index > index)) && query+=' OR '
            query+="${review_keys[$batch_index]}"
        done

        github_response=$(github_search_pull_requests "$query")
        if (($(jq '.total_count // 0' <<<"$github_response") > 100)); then
            die "GitHub returned more than 100 PRs for one issue-key batch; narrow github_org in $JIRA_CONFIG_FILE"
        fi
        github_items=$(jq -c --argjson keys "$review_keys_json" '
            [
                .items[]?
                | (((.title // "") + "\n" + (.body // "")) | ascii_upcase) as $text
                | {
                    url: .html_url,
                    merged_at: .pull_request.merged_at,
                    matched_keys: [
                        $keys[] as $key
                        | select($text | contains($key | ascii_upcase))
                        | $key
                    ]
                }
                | select(.matched_keys | length > 0)
            ]
        ' <<<"$github_response")
        pull_requests=$(jq -cn \
            --argjson existing "$pull_requests" \
            --argjson new "$github_items" \
            '$existing + $new | unique_by(.url)')
    done

    for key in "${review_keys[@]}"; do
        matches=$(jq -c --arg key "$key" \
            '[.[] | select(.matched_keys | index($key))]' <<<"$pull_requests")
        if [[ $(jq 'length' <<<"$matches") == 0 ]]; then
            errors+=("$key: Review issue has no linked GitHub pull request")
            continue
        fi

        merged_urls=$(jq -r \
            '[.[] | select(.merged_at != null) | .url] | join(", ")' <<<"$matches")
        if [[ -n "$merged_urls" ]]; then
            errors+=("$key: linked pull request is merged but the issue is still in Review: $merged_urls")
        fi
    done

    while IFS= read -r key; do
        [[ -n "$key" ]] || continue
        errors+=("$key: Maintenance issue in Review has no work logged")
    done < <(jq -r \
        --arg review "$JIRA_STATUS_REVIEW" \
        --arg maintenance "$JIRA_MAINTENANCE_LABEL" '
        def normalize: ascii_downcase | gsub("[^a-z0-9]"; "");
        .issues[]
        | select((.fields.status.name | normalize) == ($review | normalize))
        | select([.fields.labels[]? | ascii_downcase] | index($maintenance | ascii_downcase))
        | select((.fields.timespent // 0) <= 0)
        | .key
    ' <<<"$response")

    while IFS= read -r key; do
        [[ -n "$key" ]] || continue
        errors+=("$key: no story points assigned")
    done < <(jq -r \
        --arg story_points "$story_points_field" \
        --arg cutoff "$JIRA_STORY_POINTS_REQUIRED_SINCE" '
        .issues[]
        | select(.key | startswith("SC-"))
        | select((.fields.created // "")[0:10] >= $cutoff)
        | select(.fields[$story_points] == null)
        | .key
    ' <<<"$response")

    if ((${#errors[@]})); then
        printf 'ERROR: %s\n' "${errors[@]}" >&2
        printf '\n%d validation error(s).\n' "${#errors[@]}" >&2
        return 1
    fi

    printf 'OK: all %s issue(s) passed.\n' "$issue_count"
}

doctor() {
    local failed=0 command_name account

    printf 'Config: %s\n' "$JIRA_CONFIG_FILE"
    if [[ -f "$JIRA_CONFIG_FILE" ]]; then
        printf '  found\n'
        if [[ $(stat -c '%a' "$JIRA_CONFIG_FILE" 2>/dev/null || true) != 600 ]]; then
            printf '  warning: contains a token; run chmod 600 %q\n' "$JIRA_CONFIG_FILE"
        fi
    else
        printf '  not found (environment variables are also supported)\n'
    fi

    for command_name in "${REQUIRED_COMMANDS[@]}"; do
        if command -v "$command_name" >/dev/null 2>&1; then
            printf '%-8s ok\n' "$command_name"
        else
            printf '%-8s missing\n' "$command_name"
            failed=1
        fi
    done

    if [[ -z "$JIRA_URL" || -z "$JIRA_API_TOKEN" || -z "$JIRA_PROJECT" ]]; then
        printf '\nJira configuration is incomplete.\n' >&2
        print_config_example
        return 1
    fi

    if ((failed)); then
        return 1
    fi

    account=$(jira_request GET "$JIRA_API_PATH/myself" | jq -r '.displayName // .emailAddress // .name // .key')
    printf 'Jira:    authenticated as %s\n' "$account"
    printf 'Project: %s\n' "$JIRA_PROJECT"
}

usage() {
    cat <<EOF
Usage: $PROGRAM_NAME <command>

Commands:
  create    interactively create and place a Task, Bug, or Story
  change    fuzzy-find one of your non-Done issues and move it to another column
  check     validate PRs, work logs, and story points in the default change scope
  doctor    check dependencies, configuration, and Jira authentication
  help      show this help

Options:
  change --done    include issues in Jira's Done status category

Configuration defaults to $JIRA_CONFIG_FILE. JIRA_URL, JIRA_API_TOKEN,
JIRA_PROJECT, and the optional JIRA_* settings override the config.json values.
EOF
}

main() {
    load_config

    case ${1:-} in
        create)
            require_commands
            require_config
            create_issue
            ;;
        change)
            require_commands
            require_config
            (($# <= 2)) || die "change accepts only the --done option"
            case ${2:-} in
                '') change_issue false ;;
                --done) change_issue true ;;
                *) die "unknown option for change: ${2:-}" ;;
            esac
            ;;
        check)
            require_commands
            require_config
            (($# == 1)) || die "check does not accept options"
            check_issues
            ;;
        doctor)
            doctor
            ;;
        help | --help | -h)
            usage
            ;;
        '')
            usage >&2
            exit 2
            ;;
        *)
            usage >&2
            die "unknown command: $1"
            ;;
    esac
}

main "$@"
