#!/bin/bash
# system_monitor.sh - System Monitoring Toolkit
# Features: CPU, memory, disk usage with continuous monitoring and thresholds

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
print_header() { echo -e "${BLUE}=== $1 ===${NC}"; }

# Function: Get CPU usage (average from top)
cpu_usage() {
    local interval=${1:-1}
    top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | xargs printf "%.1f%%\n"
}

# Function: Memory usage (used/total percentage)
memory_usage() {
    free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2 }'
}

# Function: Disk usage for all mounts
disk_usage() {
    df -h | grep -vE '^tmpfs|cdrom' | awk 'NR>1{printf "%s: %s used (%s)\n", $1, $3, $5}'
}

# Function: Continuous monitoring loop
continuous_monitor() {
    local duration=${1:-10}  # seconds
    local interval=2
    
    print_status "Monitoring for $duration seconds (Ctrl+C to stop)"
    local end_time=$((SECONDS + duration))
    
    while [[ $SECONDS -lt $end_time ]]; do
        clear
        print_header "System Monitor (Interval: ${interval}s)"
        
        echo "CPU:  $(cpu_usage)"
        echo "RAM:  $(memory_usage)"
        echo -e "${BLUE}Disk:${NC}"
        disk_usage
        
        sleep "$interval"
    done
}

# Function: Alert if CPU > threshold
check_cpu_threshold() {
    local threshold=${1:-80}
    local usage=$(cpu_usage)
    
    if (( $(echo "$usage > $threshold" | bc -l) )); then
        print_warning "High CPU usage: $usage%"
        return 1
    fi
    print_status "CPU OK: $usage%"
}

# Function: Alert if memory > threshold
check_memory_threshold() {
    local threshold=${1:-80}
    local usage=$(memory_usage | sed 's/%//')
    
    if (( $(echo "$usage > $threshold" | bc -l) )); then
        print_warning "High Memory: $usage%"
        return 1
    fi
    print_status "Memory OK: $usage%"
}

# Main menu
system_monitor_menu() {
    while true; do
        echo -e "\n${GREEN}=== System Monitor ===${NC}"
        echo "1. Quick CPU usage"
        echo "2. Quick Memory usage"
        echo "3. Quick Disk usage"
        echo "4. Continuous monitor (10s)"
        echo "5. Check thresholds (CPU>80%, RAM>80%)"
        echo "6. Exit"
        read -r choice
        
        case "$choice" in
            1) print_status "CPU: $(cpu_usage)" ;;
            2) print_status "RAM: $(memory_usage)" ;;
            3) disk_usage ;;
            4) continuous_monitor 10 ;;
            5)
                check_cpu_threshold
                check_memory_threshold
                ;;
            6) break ;;
            *) print_error "Invalid choice" ;;
        esac
    done
}

# Dependencies check (bc for math)
if ! command -v bc &> /dev/null; then
    print_error "bc required for threshold checks. Install: sudo apt install bc"
    exit 1
fi

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    system_monitor_menu
fi

