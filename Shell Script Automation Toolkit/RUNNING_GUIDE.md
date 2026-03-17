# How to Run Shell Script Automation Toolkit 🚀

## Step-by-Step Guide (Beginner-Friendly)

### 1. Open a Terminal
Choose **one** of these:

**Linux/Ubuntu:**
```
Ctrl + Alt + T
```

**Windows WSL (Windows Subsystem for Linux):**
```
Windows Start → type "Ubuntu" or "WSL"
```

**Windows Git Bash:**
```
Right-click Desktop → "Git Bash Here"
```

### 2. Navigate to Project Directory
Copy-paste your **exact** project path:

```bash
cd "/c/Users/koush/OneDrive/Desktop/Shell Script Automation Toolkit"
```

**Verify you're in the right place:**
```bash
ls
```
*Expected output:* `README.md  RUNNING_GUIDE.md  TODO.md  scripts/`

**Common Error: "No such file or directory"**
- Check path spelling
- Use quotes if path has spaces: `cd "path with spaces"`

### 3. Make Scripts Executable
```bash
chmod +x scripts/*.sh
```

**Verify:**
```bash
ls -la scripts/
```
*Look for `-rwxr-xr-x` (executable permission)*

**Windows CMD/PowerShell Error: "chmod not recognized"**
→ Use Git Bash/WSL instead (chmod not available in Windows CMD)

### 4. Run the Main Script
```bash
./scripts/main.sh
```

**Expected Output:**
```
==========================================
    Shell Script Automation Toolkit      
==========================================
1. File Manager
2. System Monitor  
3. Process Tracker
4. Exit
```

### 5. Using the Menu
- Type number (1-4) and press **Enter**
- Follow on-screen prompts
- **File Manager**: copy/move/delete/organize files
- **System Monitor**: view CPU/RAM/disk (continuous mode available)
- **Process Tracker**: list/monitor/kill processes

**Exit any module:** Usually option `5` or `Exit`

## Common Errors & Fixes

| Error | Fix |
|-------|-----|
| `Permission denied` | Run `chmod +x scripts/*.sh` first |
| `./main.sh: No such file` | Check path: `ls scripts/main.sh` |
| `bash: ./main.sh: Bad interpreter` | Use `bash scripts/main.sh` |
| Commands not found (`ps`, `top`) | Install coreutils in WSL: `sudo apt update && sudo apt install procps` |

## Run Individual Scripts (Optional)
```bash
./scripts/file_manager.sh      # File operations
./scripts/system_monitor.sh    # CPU/RAM/disk
./scripts/process_tracker.sh   # Processes
```

## Quick One-Liner (Copy-Paste)
```bash
cd "/c/Users/koush/OneDrive/Desktop/Shell Script Automation Toolkit" && chmod +x scripts/*.sh && ./scripts/main.sh
```

**Happy Automating! 🎉**

*Pro Tip: Bookmark this guide or pin the folder*
