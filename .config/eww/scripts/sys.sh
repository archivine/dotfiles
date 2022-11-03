#!/bin/sh

PREV_TOTAL=0
PREV_IDLE=0
cpuFile="/tmp/.cpu_usage"

get_cpu() {
  if [[ -f "${cpuFile}" ]]; then
    fileCont=$(cat "${cpuFile}")
    PREV_TOTAL=$(echo "${fileCont}" | head -n 1)
    PREV_IDLE=$(echo "${fileCont}" | tail -n 1)
  fi

  CPU=($(cat /proc/stat | grep '^cpu '))
  unset CPU[0]
  IDLE=${CPU[4]}
  TOTAL=0

  for VALUE in "${CPU[@]:0:4}"; do
    let "TOTAL=$TOTAL+$VALUE"
  done

  if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
    let "DIFF_IDLE=$IDLE-$PREV_IDLE"
    let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
    let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
    echo "${DIFF_USAGE}"
  else
    echo "?"
  fi
  echo "${TOTAL}" >"${cpuFile}"
  echo "${IDLE}" >>"${cpuFile}"
}

get_mem() {
  printf "%.0f\n" $(free -m | grep Mem | awk '{print ($3/$2)*100}')
}

get_vol() {
   pactl get-sink-volume @DEFAULT_SINK@ | sed -e 's/\s\+/\n/g' | grep [0-9]% | tail -n 1 | tr -d "%"
}

if [[ "$1" == "--cpu" ]]; then
  get_cpu
elif [[ "$1" == "--mem" ]]; then
  get_mem
elif [[ "$1" == "--vol" ]]; then
  get_vol
fi

# https://github.com/sininen-blue/dotfiles/blob/main/eww/scripts/sys_info