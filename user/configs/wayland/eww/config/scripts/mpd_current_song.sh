#!/usr/bin/env bash

currentsong=""
state=""

while true; do
  state=$(mpc status %state%)
  current_song=$(mpc current)

  if [[ $state == "playing" ]]; then
    echo "  $current_song"
  elif [[ $state == "paused" && $current_song ]]; then
    echo "󰏤 $current_song"
  else
    echo "  stopped"
  fi
  mpc idle player &> /dev/null
done
