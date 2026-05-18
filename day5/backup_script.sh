#!/bin/bash
#
# Script: backup-script.sh
# Description: Production-grade directory backup with rotation
# Author: Mohammad
# Date: 2026-05-07
# Cron: 0 2 * * * /home/mohammad/devops-journey/day5/backup-script.sh
#

set -euo pipefail

# ============================================
# CONFIGURATION
# ============================================
SOURCE_DIR="${1:-$HOME/devops-journey}"     # What to backup
BACKUP_DIR="$HOME/backups"                   # Where to store backups
LOG_FILE="$BACKUP_DIR/backup.log"            # Log file
RETENTION_DAYS=7                              # Keep backups for 7 days
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"

# Colors for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ============================================
# FUNCTIONS
# ============================================

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Ensure log directory exists
    mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true
    
    case "$level" in
        INFO)
            echo -e "${GREEN}[INFO]${NC}  $timestamp - $message" | tee -a "$LOG_FILE"
            ;;
        WARN)
            echo -e "${YELLOW}[WARN]${NC}  $timestamp - $message" | tee -a "$LOG_FILE"
            ;;
        ERROR)
            echo -e "${RED}[ERROR]${NC} $timestamp - $message" | tee -a "$LOG_FILE" >&2
            ;;
    esac
}

cleanup() {
    local exit_code=$?
    
    if [[ $exit_code -ne 0 ]]; then
        log "ERROR" "Backup failed with exit code: $exit_code"
    fi
    
    # Remove incomplete backup if script failed
    if [[ -f "$BACKUP_FILE" ]] && [[ $exit_code -ne 0 ]]; then
        rm -f "$BACKUP_FILE"
        log "WARN" "Removed incomplete backup: $BACKUP_FILE"
    fi
}

trap cleanup EXIT

validate_source() {
    if [[ ! -d "$SOURCE_DIR" ]]; then
        log "ERROR" "Source directory does not exist: $SOURCE_DIR"
        exit 1
    fi
    
    if [[ -z "$(ls -A "$SOURCE_DIR" 2>/dev/null)" ]]; then
        log "WARN" "Source directory is empty: $SOURCE_DIR"
    fi
}

create_backup_dir() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR"
        log "INFO" "Created backup directory: $BACKUP_DIR"
    fi
}

perform_backup() {
    log "INFO" "Starting backup of $SOURCE_DIR"
    
    local size_before
    size_before=$(du -sh "$SOURCE_DIR" 2>/dev/null | cut -f1)
    log "INFO" "Source size: $size_before"
    
    # Create compressed archive
    if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null; then
        local backup_size
        backup_size=$(du -sh "$BACKUP_FILE" | cut -f1)
        log "INFO" "Backup created: $BACKUP_FILE ($backup_size)"
        
        # Create checksum for integrity verification
        sha256sum "$BACKUP_FILE" > "$BACKUP_FILE.sha256"
        log "INFO" "Checksum created: $BACKUP_FILE.sha256"
        
        return 0
    else
        log "ERROR" "Failed to create backup archive"
        return 1
    fi
}

rotate_backups() {
    log "INFO" "Rotating backups older than $RETENTION_DAYS days..."
    
    local deleted_count=0
    
    # Find and delete old backups
    while IFS= read -r old_backup; do
        if [[ -f "$old_backup" ]]; then
            rm -f "$old_backup" "${old_backup}.sha256" 2>/dev/null
            log "INFO" "Deleted old backup: $(basename "$old_backup")"
            ((deleted_count++))
        fi
    done < <(find "$BACKUP_DIR" -name "backup-*.tar.gz" -mtime +$RETENTION_DAYS)
    
    if [[ $deleted_count -eq 0 ]]; then
        log "INFO" "No backups to rotate (nothing older than $RETENTION_DAYS days)"
    else
        log "INFO" "Rotated $deleted_count old backup(s)"
    fi
}

list_recent_backups() {
    log "INFO" "Recent backups:"
    ls -lht "$BACKUP_DIR"/backup-*.tar.gz 2>/dev/null | head -5 | while read -r line; do
        log "INFO" "  $line"
    done
}

# ============================================
# MAIN
# ============================================
main() {
    # Ensure backup directory exists BEFORE any logging
    if [[ ! -d "$BACKUP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR"
        echo "Created backup directory: $BACKUP_DIR"  # Simple echo, log not needed yet
    fi

    log "INFO" "========================================="
    log "INFO" "  BACKUP SCRIPT STARTED"
    log "INFO" "========================================="
    
    validate_source
#    create_backup_dir
    perform_backup
    rotate_backups
    list_recent_backups
    
    log "INFO" "Backup completed successfully!"
    log "INFO" "========================================="
}

main "$@"
