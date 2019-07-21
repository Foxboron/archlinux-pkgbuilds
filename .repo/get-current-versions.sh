#!/bin/bash
while IFS= read -r -d '' srcinfo; do
	printf "%s %s\n" "$(awk '/pkgbase/ {print $3}' "$srcinfo")" "$(awk '/pkgver/ {print $3}' "$srcinfo")"
done < <(find . -maxdepth 2 -name ".SRCINFO" -print0)
