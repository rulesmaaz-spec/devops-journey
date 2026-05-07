#!/bin/bash
# Special variables

echo "Script name: $0"            # Name of the script
echo "First argument: $1"         # First argument passed
echo "Second argument: $2"        # Second argument
echo "All argument: $@"           # All argument as separated word
echo "All argument (single): $*"  # All argument as single string
echo "Number of argument: $#"     # COunt of argument
echo "Process ID: $$"             # PID of this script
echo "Last command exit code: $?" # 0=success, non-zero=failure
echo "Last background PID: $!"    # PID of last background command
