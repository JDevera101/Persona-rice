#!/bin/bash

if pgrep -x "wf-recorder" >/dev/null; then
  # If already recording, stop it gracefully
  pkill -INT wf-recorder
  notify-send "Screen Recorder" "Recording saved to Videos!"
else
  # Record desktop audio: the monitor of whatever output you are using right now.
  sink="$(pactl get-default-sink 2>/dev/null)"
  audio_dev="${sink:+$sink.monitor}"
  # Fallback: your laptop speaker monitor
  audio_dev="${audio_dev:-alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink.monitor}"

  wf-recorder -o eDP-1 --audio="$audio_dev" -f "$HOME/Videos/recording-$(date +%Y%m%d_%H%M%S).mp4" &
  notify-send "Screen Recorder" "Recording started (with audio)..."
fi
