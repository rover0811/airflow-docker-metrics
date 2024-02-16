#!/bin/bash


TIMEOUT=15
QUIET=0
WAIT=2

echoerr() {
  if [[ "$QUIET" -ne 1 ]]; then echo "$@" 1>&2; fi
}

wait_for() {
  for i in `seq $TIMEOUT` ; do
    nc -z "$HOST" "$PORT" > /dev/null 2>&1

    result=$?
    if [[ $result -eq 0 ]]; then
      if [[ "$QUIET" -ne 1 ]]; then echo "Connection to $HOST:$PORT succeeded."
      fi
      return 0
    fi

    sleep $WAIT
  done

  echo "Operation timed out" >&2
  return 1
}

parse_arguments() {
  HOST=`echo $1 | cut -d : -f 1`
  PORT=`echo $1 | cut -d : -f 2`

  if [[ "$2" == "--timeout="* ]]; then
    TIMEOUT="${2//--timeout=/}"
  fi
}

parse_arguments "$@"

wait_for
