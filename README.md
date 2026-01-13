This script was tested with the Guide TD210.

It was written on macOS using Homebrew installed bash so the path in the first line will need to be modified when running on linux.

The script uses Curl so that also needs to be installed. Not all arguments are required and only the provided options will be applied to the thermal device.

Usage: gcontrol.sh [-csbozphe]

Controls Guide thermal imaging devices over WiFi.

OPTIONS:
  -c  |  --color      Set color mode: white, black, red, iron, blue
  -s  |  --scene      Set scene mode: natural, enhanced, highlight
  -b  |  --brightness Set brightness: 1 .. 10
  -o  |  --contrast   Set contrast: 1 .. 10
  -z  |  --zoom       Set zoom: 1, 3
  -p  |  --pip        Set picture-in-picture mode: left, mid, right, off
  -h  |  --hotspot    Set hotspot tracking: on, off
  -e  |  --enhance    Set image enhancement: on, off

EXAMPLE:

gcontrol.sh -c white -s highlight -b 5 -c 5 -z 1.5 -p off -h on -e on
