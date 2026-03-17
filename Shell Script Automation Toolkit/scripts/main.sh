#!/bin/bash
# main.sh - Main Menu for Shell Script Automation Toolkit
# Launches all modules in a loop-based menu

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
print_banner() {
    echo -e "${CYAN}"
    echo "=========================================="
    echo "    Shell Script Automation Toolkit      "
    echo "=========================================="
    echo -e "${NC}"
}

print_status() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}" >&2; }

# Check if scripts directory exists
if [[ ! -d "scripts" ]]; then
    print_error "scripts/ directory not found!"
    exit 1
fi

# Source the modules (for functions) or run them
run_file_manager() {
    bash ./scripts/file_manager.sh
}

run_system_monitor() {
    bash ./scripts/system_monitor.sh
}

run_process_tracker() {
    bash ./scripts/process_tracker.sh
}

# Main menu loop
main_menu() {
    while true; do
        clear
        print_banner
        echo -e "${GREEN}Main Menu:${NC}"
        echo "1. File Manager (copy/move/delete/organize)"
        echo "2. System Monitor (CPU/RAM/Disk)"
        echo "3. Process Tracker (list/monitor/kill)"
        echo "4. Exit"
        echo
        read -r -p "Select option (1-4): " choice
        
        case "$choice" in
            1) print_status "Launching File Manager..."; run_file_manager ;;
            2) print_status "Launching System Monitor..."; run_system_monitor ;;
            3) print_status "Launching Process Tracker..."; run_process_tracker ;;
            4) print_status "Goodbye!"; exit 0 ;;
            *)
                print_error "Invalid option. Please choose 1-4."
                sleep 1
                ;;
        esac
    done
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_menu
fi

