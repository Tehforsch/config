#!/usr/bin/env bash

set -euo pipefail

readonly device_address="28:11:A5:E1:3E:C0"
readonly a2dp_uuid="0000110b-0000-1000-8000-00805f9b34fb"
readonly card_name="bluez_card.${device_address//:/_}"
readonly profile="a2dp-sink"

echo "Connecting the headphones' A2DP service..."
bluetoothctl connect "$device_address" "$a2dp_uuid"

# WirePlumber may need a moment to add the newly connected A2DP profile.
for _ in {1..10}; do
  if pactl set-card-profile "$card_name" "$profile" 2>/dev/null; then
    echo "Switched headphones to A2DP/AAC stereo."
    exit 0
  fi
  sleep 0.5
done

echo "Failed to switch $card_name to $profile." >&2
echo "Try turning the headphones off and on, then run this script again." >&2
exit 1
