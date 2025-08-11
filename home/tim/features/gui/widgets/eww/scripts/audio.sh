#!/usr/bin/env bash

volume_get() {
  if pactl get-sink-mute @DEFAULT_SINK@ | grep yes > /dev/null; then
    echo "x%"
  else
    pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -n 1
  fi
}

volume_set() {
  local volume="$1"
  pactl set-sink-volume @DEFAULT_SINK@ "$volume"%
}

volume_up() {
  pactl set-sink-volume @DEFAULT_SINK@ +1%
}

volume_down() {
  pactl set-sink-volume @DEFAULT_SINK@ -1%
}

volume_mute() {
  pactl set-sink-mute @DEFAULT_SINK@ toggle
}

volume_subscribe() {
  volume_get

  pactl subscribe | while read -r event; do
    if [[ ! "$event" =~ "sink" ]]; then
      continue
    fi

    volume_get
  done
}

main() {

  case "$1" in
    "get")
      volume_get
      ;;
    "set")
      volume_set "$2"
      ;;
    "subscribe")
      volume_subscribe
      ;;
    "up")
      volume_up
      ;;
    "down")
      volume_down
      ;;
    "mute")
      volume_mute
      ;;
    *)
      echo "Usage: $0 {get|subscribe|set VOLUME|up|down|mute}"
      exit 1
      ;;
  esac
}

main "$@"

