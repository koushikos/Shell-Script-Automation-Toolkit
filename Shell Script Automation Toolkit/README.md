# Shell Script Automation Toolkit

A complete Bash-based toolkit for automating common Linux/Unix system tasks.

## Folder Structure
```
Shell Script Automation Toolkit/
├── TODO.md                 # Progress tracking
├── README.md              # This file
└── scripts/
    ├── file_manager.sh    # File operations
    ├── system_monitor.sh  # System monitoring
    ├── process_tracker.sh # Process management
    └── main.sh            # Menu launcher
```

## Features
- **File Manager**: Copy/move/delete/organize files (batch support)
- **System Monitor**: Real-time CPU/RAM/disk usage + thresholds
- **Process Tracker**: List/search/monitor/kill processes
- **Main Menu**: User-friendly loop-based interface

## Quick Start

1. **Make scripts executable**:
   ```bash
   chmod +x scripts/*.sh
   ```

2. **Run the toolkit**:
   ```bash
   ./scripts/main.sh
   ```

## Sample Usage

```
$ ./scripts/main.sh

==========================================
    Shell Script Automation Toolkit      
==========================================
Main Menu:
1. File Manager (copy/move/delete/organize)
2. System Monitor (CPU/RAM/Disk)
3. Process Tracker (list/monitor/kill)
4. Exit
Select option: 1
```

### File Manager Example
- Copy: Enter sources and dest dir
- Organize: `organize_files /path/to/dir` sorts by extension

### System Monitor Example
```
CPU:  12.5%
RAM:  45.2%
Disk: /dev/sda1: 20G used (65%)
```

### Process Tracker Example
```
Top 20 processes by CPU usage:
USER PID %CPU %MEM ... COMMAND
```

## Requirements
- Bash shell (Linux/WSL/macOS)
- Core utils: `ps`, `top`, `free`, `df`, `pgrep`, `pkill`
- `bc` for thresholds (auto-check)

## Testing
Tested on Ubuntu 22.04 WSL. Handles errors, validates inputs.

Enjoy automating your system tasks!

