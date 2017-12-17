##!/bin/bash

# Modify this to change the default if you don't want to use the
# optional argument. E.g: scale=${1:-1.25} for 1.25x scaling.
scale=${1:-1.5}

echo "Running $(basename $0)"
cd "$(dirname "$0")"
echo "`./display_scale.sh 1.0`"
echo "`./display_scale.sh $scale`"
