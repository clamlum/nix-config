#!/usr/bin/env bash
MAXTAG=9

mon=$(mmsg get focusing-client 2>/dev/null | jq -r '.monitor // .client.monitor // empty')
[ -z "$mon" ] && mon=$(mmsg get cursorpos 2>/dev/null | jq -r '.monitor // empty')
[ -z "$mon" ] && exit 1

tags=$(mmsg get tags "$mon") || exit 1
cur=$(jq -r '.active_tags[0]' <<<"$tags")
occ=$(jq -r '[.tags[] | select(.client_count > 0) | .index] | sort | .[]' <<<"$tags")
last=$(tail -n1 <<<"$occ"); last=${last:-0}

target=""
case "$1" in
  down|send-down)
    target=$(awk -v c="$cur" '$1 > c {print $1; exit}' <<<"$occ")
    if [ -z "$target" ] && [ "$cur" -eq "$last" ] && [ "$last" -lt "$MAXTAG" ]; then
      target=$((last + 1))
    fi
    ;;
  up|send-up)
    target=$(awk -v c="$cur" '$1 < c {t = $1} END {if (t) print t}' <<<"$occ")
    ;;
  *) exit 1 ;;
esac

[ -z "$target" ] && exit 0

case "$1" in
  send-*) mmsg dispatch "tag,$target"; mmsg dispatch "view,$target" ;;
  *)      mmsg dispatch "view,$target" ;;
esac
