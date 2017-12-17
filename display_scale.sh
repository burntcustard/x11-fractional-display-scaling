##!/bin/bash

# Modify this to change the default if you don't want to use the
# optional argument. E.g: scale=${1:-1.25} for 1.25x scaling.
scale=${1:-1.5}

echo "Running $(basename $0)"

xdg=$(echo $XDG_SESSION_TYPE)
if [[ $xdg != "x11" ]]; then
    echo "ERROR: Running $xdg display server rather than x11"
    exit 1
fi

if ! [[ $scale =~ ^[1-9](\.[0-9]*)?$ ]]; then
    echo "ERROR: Scaling factor must be 1-10"
    exit 1
fi

xrandr=$(xrandr -q)  # Get current screen properties

# Get the current panning value (i.e. up/down scaled resolution):
currentPan=$(xrandr |
             grep -o "current[^,]\+" |  # Get "current [pan]" section
             cut -c8- |                 # Remove "current" (first 8 chars)
             tr -d "[:space:]")         # Remove all whitespace

# Get max res supported by hardware:
res=$("xrandr" |
      sed '3!d' |      # Get line 3 (should be the the correct line...)
      xargs |          # Remove leading whitespace
      grep -o '^\S*')  # Remove stuff after resolution (starting with 1st ' ')

# Get display identifier:
display=$("xrandr" |
          sed '2!d' |      # Get line 2 (should be the the correct line...)
          grep -o '^\S*')  # Remove stuff after display (starting with 1st ' ')

xRes=$(echo $res | cut -d "x" -f 1)
yRes=$(echo $res | cut -d "x" -f 2)
xPan=$(echo "scale=0;($xRes*$scale)/1" | bc)
yPan=$(echo "scale=0;($yRes*$scale)/1" | bc)
pan=$xPan'x'$yPan
scale=$scale'x'$scale  # Change scale from "1.5" to "1.5x1.5"

echo "Intended scaling:           $scale"
echo "Display identifier:         $display"
echo "Max hardware resolution:    $res"
echo "Current panning resolution: $currentPan"
echo "New panning resolution:     $pan"

if [ "$currentPan" != "$pan" ]; then
    xrandr --output $display --scale $scale --panning $pan
else
    echo "Not changing scaling as current and intended resolutions match."
fi
