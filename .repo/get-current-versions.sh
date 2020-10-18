#!/bin/bash
while IFS= read -r -d '' srcinfo; do
	if ! git show ":$srcinfo" &>/dev/null; then
		continue
	fi
	printf "%s %s\n" "$(awk '/pkgbase/ {print $3}' <(git show ":$srcinfo"))" "$(awk '/pkgver/ {print $3}' <(git show ":$srcinfo"))"
done < <(find . -maxdepth 2 -name ".SRCINFO" -print0)
