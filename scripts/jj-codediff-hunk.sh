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
git -C "$output" apply --check --unidiff-zero --recount --whitespace=nowarn "$JJ_CODEDIFF_PATCH"
git -C "$output" apply --unidiff-zero --recount --whitespace=nowarn "$JJ_CODEDIFF_PATCH"
