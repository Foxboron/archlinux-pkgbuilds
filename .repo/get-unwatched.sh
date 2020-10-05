#!/usr/bin/bash
readonly MAINTAINER="Foxboron"

blacklist=( __config__ go-tools python2-docs minicom perl-anyevent-i3)

sort <(curl -s "https://www.archlinux.org/packages/search/json/?sort=&q=&maintainer=$MAINTAINER&flagged=" | jq -r '.results[].pkgbase' | sort | uniq) <(grep -oP '^\[\K[^\]]+' .repo/packages.toml) <(printf "%s\n" "${blacklist[@]}") | uniq -u
