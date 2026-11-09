#!/bin/sh

tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

yazi "$@" --cwd-file="$tmp"

cwd="$(cat "$tmp" 2>/dev/null)"

rm -f "$tmp"

if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && [ -d "$cwd" ]; then
    echo "$cwd"
fi