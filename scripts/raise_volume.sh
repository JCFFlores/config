#!/bin/dash

SINK=$(pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1)
VOL=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')

pactl set-sink-mute "$SINK" 0

if test `expr $VOL + 5` -gt 100;
then
    pactl set-sink-volume "$SINK" 100%
else
    pactl set-sink-volume "$SINK" +5%
fi

