#!/bin/bash
# process_tracker.sh - Process Tracking Toolkit
# Features: list, monitor, kill processes with search and PID validation

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Function: List all processes (top 20 by CPU)
list_processes() {
    print_status "Top 20 processes by CPU usage:"
    ps aux --sort=-%cpu | head -21 | awk '
    NR==1 {print "\nUSER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND"}
    NR>1 {print $0}'
}

# Function: Search processes by name
search_processes() {
    local pattern="$1"
    if [[ -z "$pattern" ]]; then
        echo "Enter process name/pattern:"
        read -r pattern
    fi
    print_status "Processes matching '$pattern':"
    ps aux | grep -i "$pattern" | grep -v grep
}

# Function: Monitor specific process by PID or name
monitor_process() {
    local target="$1"
    if [[ -z "$target" ]]; then
        echo "Enter PID or process name:"
        read -r target
    fi
    
    # Continuous monitoring with while loop
    print_status "Monitoring '$target' (Ctrl+C to stop)"
    while true; do
        clear
        echo "Process: $target"
        if ps aux | grep -q "^[^ ]* *$target"; then
            ps aux | grep "$target" | grep -v grep | head -1
            sleep 2
        else
            print_error "Process '$target' not found!"
            break
        fi
    done
}

# Function: Validate PID exists
pid_exists() {
    local pid="$1"
    kill -0 "$pid" 2>/dev/null
}

# Function: Kill process by PID (with confirmation)
kill_process() {
    local pid="$1"
    if [[ -z "$pid" ]]; then
        echo "Enter PID to kill:"
        read -r pid
    fi
    
    if pid_exists "$pid"; then
        echo "Kill PID $pid? (y/N):"
        read -r confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            kill "$pid" && print_status "Killed PID: $pid" || print_error "Failed to kill PID: $pid"
        else
            print_warning "Kill cancelled"
        fi
    else
        print_error "PID $pid not found or no permission"
    fi
}

# Function: Kill process by name (all matching)
kill_by_name() {
    local name="$1"
    if [[ -z "$name" ]]; then
        echo "Enter process name:"
        read -r name
    fi
    
    local pids=$(pgrep -f "$name")
    if [[ -n "$pids" ]]; then
        echo "Found PIDs: $pids"
        echo "Kill all? (y/N):"
        read -r confirm
        if [[ "$confirm" == "y" ]]; then
            pkill -f "$name" && print_status "Killed processes: $name" || print_error "Failed to kill $name"
        fi
    else
        print_error "No processes found: $name"
    fi
}

# Main menu
process_tracker_menu() {
    while true; do
        echo -e "\n${GREEN}=== Process Tracker ===${NC}"
        echo "1. List top processes"
        echo "2. Search processes"
        echo "3. Monitor process"
        echo "4. Kill by PID"
        echo "5. Kill by name"
        echo "6. Exit"
        read -r choice
        
        case "$choice" in
            1) list_processes ;;
            2) search_processes "" ;;
            3) monitor_process "" ;;
            4) kill_process "" ;;
            5) kill_by_name "" ;;
            6) break ;;
            *) print_error "Invalid choice" ;;
        esac
        echo "Press Enter to continue..."
        read -r
    done
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    process_tracker_menu
fi

