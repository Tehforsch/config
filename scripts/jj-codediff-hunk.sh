#!/bin/sh
set -eu

if [ "$#" -ne 3 ]; then
	echo "usage: jj-codediff-hunk.sh LEFT RIGHT OUTPUT" >&2
	exit 2
fi

left=$1
output=$3

: "${JJ_CODEDIFF_PATCH:?missing path to the selected CodeDiff patch}"

# JJ initializes output from the right side. Reset it to the left side so that
# applying one patch selects exactly that patch and no other changes.
rsync -a --checksum --delete --exclude=/JJ-INSTRUCTIONS "$left/" "$output/"
if ! check_output=$(LC_ALL=C git -C "$output" apply --check --verbose --unidiff-zero --recount --whitespace=nowarn "$JJ_CODEDIFF_PATCH" 2>&1); then
	printf '%s\n' "$check_output" >&2
	exit 1
fi
expected_line=$(sed -n 's/^@@ -\([0-9][0-9]*\).*/\1/p' "$JJ_CODEDIFF_PATCH")
applied_line=$(printf '%s\n' "$check_output" | sed -n 's/^Hunk #[0-9][0-9]* succeeded at \([0-9][0-9]*\).*/\1/p')
if [ -n "$applied_line" ] && [ "$applied_line" != "$expected_line" ]; then
	printf '%s\n' "selected hunk no longer applies at its displayed line; refusing to move it" >&2
	exit 1
fi
git -C "$output" apply --unidiff-zero --recount --whitespace=nowarn "$JJ_CODEDIFF_PATCH"
