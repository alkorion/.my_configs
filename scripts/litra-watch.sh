#!/bin/bash
# litra-watch.sh
# Watches macOS AVCaptureSession events and toggles the Litra light.
# Uses a debounce timer to ignore the brief on/off flicker Firefox emits
# during camera negotiation at session startup.

LITRA="$(brew --prefix)/bin/litra"
DEBOUNCE=2  # seconds to wait before acting on an event

timer_pid=""
pending_action=""

act() {
  local action=$1
  # Kill any pending timer — we're superseding it
  if [ -n "$timer_pid" ] && kill -0 "$timer_pid" 2>/dev/null; then
    kill "$timer_pid" 2>/dev/null
  fi
  pending_action=$action
  # Start a new background timer; when it fires, execute the action
  (sleep $DEBOUNCE && $LITRA $pending_action) &
  timer_pid=$!
}

log stream --predicate 'subsystem contains "com.apple.cameracapture" and composedMessage contains "_setRunning:" and composedMessage contains "running ->"' 2>/dev/null | \
while read -r line; do
  if echo "$line" | grep -q "running -> 1"; then
    act on
  elif echo "$line" | grep -q "running -> 0"; then
    act off
  fi
done
