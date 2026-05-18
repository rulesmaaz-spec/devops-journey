#!/bin/bash
set -euo pipefail

# ============================================
# LOGGING FUNCTIONS
# ============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC}  $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC}  $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

# ============================================
# ERROR HANDLER
# ============================================
error_exit() {
    local error_message="$1"
    local exit_code="${2:-1}"
    
    log_error "$error_message"
    log_error "Script terminated with exit code: $exit_code"
    log_error "Line number: ${BASH_LINENO[0]}"
    log_error "Function: ${FUNCNAME[1]:-main}"
    
    exit "$exit_code"
}

# ============================================
# VALIDATION FUNCTIONS
# ============================================
validate_file_exists() {
    local file_path="$1"
    
    if [[ ! -f "$file_path" ]]; then
        error_exit "File not found: $file_path" 2
    fi
    log_info "File exists: $file_path"
}

validate_directory_exists() {
    local dir_path="$1"
    
    if [[ ! -d "$dir_path" ]]; then
        error_exit "Directory not found: $dir_path" 2
    fi
    log_info "Directory exists: $dir_path"
}

# ============================================
# MAIN SCRIPT
# ============================================
main() {
    log_info "Script started"
    
    # Test with existing file
    validate_file_exists "/etc/hostname"
    
    # Test with existing directory
    validate_directory_exists "/tmp"
    
    # This will fail (uncomment to test)
    # validate_file_exists "/nonexistent/file.txt"
    
    # This would only run if we didn't set -e or use error_exit
    log_info "All validations passed!"
    log_info "Script completed successfully"
}

# Run main function
main "$@"
