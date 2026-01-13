#!/opt/homebrew/bin/bash -e
#/ Guide Control
#/ Usage: gcontrol.sh [-csbozphe]
#/
#/ Controls Guide thermal imaging devices over WiFi. Tested with TD210.
#/
#/ OPTIONS:
#/   -c  |  --color      Set color mode: white, black, red, iron, blue
#/   -s  |  --scene      Set scene mode: natural, enhanced, highlight
#/   -b  |  --brightness Set brightness: 1 .. 10
#/   -o  |  --contrast   Set contrast: 1 .. 10
#/   -z  |  --zoom       Set zoom: 1, 3
#/   -p  |  --pip        Set picture-in-picture mode: left, mid, right, off
#/   -h  |  --hotspot    Set hotspot tracking: on, off
#/   -e  |  --enhance    Set image enhancement: on, off
#/
#/ EXAMPLE:
#/
#/ gcontrol.sh -c white -s highlight -b 5 -c 5 -z 1.5 -p off -h on -e on

declare -A colors
colors["white"]="\x00\x04\x00\x00\x00\x00\x01"
colors["black"]="\x00\x04\x00\x00\x00\x09\x08"
colors["red"]="\x00\x04\x00\x00\x00\x0a\x0b"
colors["iron"]="\x00\x04\x00\x00\x00\x02\x03"
colors["blue"]="\x00\x04\x00\x00\x00\x04\x05"

declare -A scenes
scenes["natural"]="\x03\x07\x00\x00\x00\x00\x01"
scenes["enhanced"]="\x03\x07\x00\x00\x00\x05\x04"
scenes["highlight"]="\x03\x07\x00\x00\x00\x06\x07"

declare -A brightnesses
brightnesses[1]="\x03\x09\x00\x00\x00\x01\x0e"
brightnesses[2]="\x03\x09\x00\x00\x00\x02\x0d"
brightnesses[3]="\x03\x09\x00\x00\x00\x03\x0c"
brightnesses[4]="\x03\x09\x00\x00\x00\x04\x0b"
brightnesses[5]="\x03\x09\x00\x00\x00\x05\x0a"
brightnesses[6]="\x03\x09\x00\x00\x00\x06\x09"
brightnesses[7]="\x03\x09\x00\x00\x00\x07\x08"
brightnesses[8]="\x03\x09\x00\x00\x00\x08\x07"
brightnesses[9]="\x03\x09\x00\x00\x00\x09\x06"
brightnesses[10]="\x03\x09\x00\x00\x00\x0a\x05"

declare -A contrasts
contrasts[1]="\x03\x0a\x00\x00\x00\x01\x0d"
contrasts[2]="\x03\x0a\x00\x00\x00\x02\x0e"
contrasts[3]="\x03\x0a\x00\x00\x00\x03\x0f"
contrasts[4]="\x03\x0a\x00\x00\x00\x04\x08"
contrasts[5]="\x03\x0a\x00\x00\x00\x05\x09"
contrasts[6]="\x03\x0a\x00\x00\x00\x06\x0a"
contrasts[7]="\x03\x0a\x00\x00\x00\x07\x0b"
contrasts[8]="\x03\x0a\x00\x00\x00\x08\x04"
contrasts[9]="\x03\x0a\x00\x00\x00\x09\x05"
contrasts[10]="\x03\x0a\x00\x00\x00\x0a\x06"

declare -A zooms
zooms[1]="0"
zooms[3]="1"

declare -A pips
pips["left"]="left"
pips["mid"]="mid"
pips["right"]="right"
pips["off"]="off"

declare -A hotspots
hotspots["on"]="\x00\x09\x00\x00\x00\x01\x0d"
hotspots["off"]="\x00\x09\x00\x00\x00\x00\x0c"

declare -A enhancements
enhancements["on"]="\x03\x0b\x00\x00\x00\x00\x0d"
enhancements["off"]="\x03\x0b\x00\x00\x00\x01\x0c"

api="http://192.168.42.1/api/v1"
custom_prefix="\x55\xaa\x07\x02"
custom_suffix="\xf0"

function print_help() { grep '^#/' < "$0" | cut -c4-; exit 1; }
function print_error() { echo "ERROR: $1"; exit 1; }

if [ $# -lt 1 ]; then print_help; fi

# process command line arguments
ARGUMENTS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--color)
      echo -e "${custom_prefix}${colors["$2"]}${custom_suffix}" | curl -X POST --data-binary @- -H 'Content-Type: application/customdata' ${api}/files/customdata
      shift 2
      ;;
    -s|--scene)
      echo -e "${custom_prefix}${scenes["$2"]}${custom_suffix}" | curl -X POST --data-binary @- -H 'Content-Type: application/customdata' ${api}/files/customdata
      shift 2
      ;;
    -b|--brightness)
      echo -e "${custom_prefix}${brightnesses["$2"]}${custom_suffix}" | curl -X POST --data-binary @- -H 'Content-Type: application/customdata' ${api}/files/customdata
      shift 2
      ;;
    -o|--contrast)
      echo -e "${custom_prefix}${contrasts["$2"]}${custom_suffix}" | curl -X POST --data-binary @- -H 'Content-Type: application/customdata' ${api}/files/customdata
      shift 2
      ;;
    -z|--zoom)
      curl -X PUT -H "Content-Type: application/json" --data "{\"value\":\"${zooms[$2]}\"}" ${api}/camera/multiplezoom
      shift 2
      ;;
    -p|--pip)
      curl -v -X PUT -H "Content-Type: application/json" --data "{\"value\":\"${pips[$2]}\"}" ${api}/camera/pip
      shift 2
      ;;
    -h|--hotspot)
      echo -e "${custom_prefix}${hotspots["$2"]}${custom_suffix}" | curl -X POST --data-binary @- -H 'Content-Type: application/customdata' ${api}/files/customdata
      shift 2
      ;;
    -e|--enhance)
      echo -e "${custom_prefix}${enhancements["$2"]}${custom_suffix}" | curl -X POST --data-binary @- -H 'Content-Type: application/customdata' ${api}/files/customdata
      shift 2
      ;;
    -*|--*)
      print_help ;;
    *)
      ARGUMENTS+=("$1")
      shift
      ;;
  esac
done
set -- "${ARGUMENTS[@]}"