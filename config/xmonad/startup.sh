#!/bin/sh

# System tray
if [ -z "$(pgrep trayer)" ] ; then
    trayer --edge top \
           --align right \
           --widthtype percent \
           --height 24 \
           --alpha 0 \
           --transparent true \
           --width 5 \
           --tint 0x282c34 &
fi

# Wallpaper
if [ -z "$(pgrep feh)" ] ; then
    ./.fehbg &
fi

# picom
#if [ -z "$(pgrep picom)" ] ; then
#    picom -b &
#fi