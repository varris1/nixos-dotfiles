#!/usr/bin/env cached-nix-shell
#! nix-shell -i bash -p pulsemixer
#
volume=$(pamixer --get-volume)

if [[ $volume -eq 0 ]]; then
  echo " $volume%"
elif [[ $volume -lt 25 ]]; then
  echo " $volume%"
elif [[ $volume -lt 50 ]]; then
  echo " $volume%"
elif [[ $volume -lt 75 ]]; then
  echo "󰕾 $volume%"
else
  echo " $volume%"
fi
