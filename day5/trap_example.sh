#!/bin/bash

set -euo pipefail

#===========================
#CLEANUP FUNCTION
#===========================
cleanup() {
     local exit_code=$?

     echo "===================================="
     echo "       CLEANUP STARTED"
     echo "===================================="
     echo "Script Exit Code: $exit_code"
     echo "Cleaning up temporary file..."

     # remove temp directory if exist
    # if [[ -d "$TEMP_DIR" ]]; then
     #    rm -rf "$TEMP_DIR"
      #   echo "Removed: $TEMP_DIR"
    # fi

     # remove temp directory if VARIABLE IS SET and directory exists
     if [[ -n "${TEMP_DIR:-}" ]] && [[ -d "$TEMP_DIR" ]]; then
         rm -rf "$TEMP_DIR"
         echo "Removed: $TEMP_DIR"
     fi

     echo "Cleanp complete at $(date)"
     echo "===================================="

      exit $exit_code
}

# set trap - calls clean up on EXIT, SIGINT (Ctrl C), SIGTERM
trap cleanup EXIT INT TERM

#==================================
#         MAIN SCRIPT
#==================================
echo "Script started at: $(date)"
echo "PID: $$"

# create temporary directory
TEMP_DIR=$(mktemp -d -t myapp-XXXXXX)
echo "Created temp directory $TEMP_DIR"

# do some work (creating temp file)
for i in ${1..5}; do
  echo "Processing step $i.."
  echo "Data for step $i" > "$TEMP_DIR/step-$i.txt"
  sleep 1
done

echo "work complete"
