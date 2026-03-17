#!/bin/bash
# file_manager.sh - File Management Toolkit
# Features: copy, move, delete, organize files with validation and batch support

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Function: Validate if file exists
file_exists() {
    local file_path="$1"
    [[ -f "$file_path" ]] || { print_error "File does not exist: $file_path"; return 1; }
}

# Function: Validate if directory exists
dir_exists() {
    local dir_path="$1"
    [[ -d "$dir_path" ]] || { print_error "Directory does not exist: $dir_path"; return 1; }
}

# Function: Copy single or multiple files
copy_file() {
    local src="$1"
    local dest="$2"
    
    file_exists "$src" || return 1
    
    if [[ -d "$src" ]]; then
        # Recursive copy for directories
        cp -r "$src" "$dest"
    else
        cp "$src" "$dest"
    fi
    print_status "Copied: $src -> $dest"
}

# Function: Copy multiple files (batch)
copy_files() {
    echo "Enter source files (space-separated):"
    read -r -a sources
    echo "Enter destination directory:"
    read -r dest
    
    dir_exists "$dest" || mkdir -p "$dest"
    
    for src in "${sources[@]}"; do
        file_exists "$src" && copy_file "$src" "$dest/"
    done
}

# Function: Move single or multiple files
move_file() {
    local src="$1"
    local dest="$2"
    
    file_exists "$src" || return 1
    
    if [[ -d "$src" ]]; then
        mv "$src" "$dest"
    else
        mv "$src" "$dest"
    fi
    print_status "Moved: $src -> $dest"
}

# Function: Move multiple files
move_files() {
    echo "Enter source files (space-separated):"
    read -r -a sources
    echo "Enter destination directory:"
    read -r dest
    
    dir_exists "$dest" || mkdir -p "$dest"
    
    for src in "${sources[@]}"; do
        file_exists "$src" && move_file "$src" "$dest/"
    done
}

# Function: Delete file or directory (with confirmation)
delete_file() {
    local path="$1"
    
    if [[ -z "$path" ]]; then
        print_error "No path provided"
        return 1
    fi
    
    if [[ -e "$path" ]]; then
        echo "Delete $path? (y/N):"
        read -r confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            if [[ -d "$path" ]]; then
                rm -rf "$path"
            else
                rm -f "$path"
            fi
            print_status "Deleted: $path"
        else
            print_warning "Deletion cancelled"
        fi
    else
        print_error "Path not found: $path"
    fi
}

# Function: Organize files by extension into folders (e.g., *.txt -> txt/)
organize_files() {
    local dir="$1"
    
    [[ -d "$dir" ]] || { print_error "Directory not found: $dir"; return 1; }
    
    cd "$dir" || return 1
    
    # Common extensions
    local extensions=("txt" "jpg" "png" "pdf" "sh" "log")
    
    for ext in "${extensions[@]}"; do
        mkdir -p "$ext"
        # Use for loop to move matching files
        for file in *."$ext"; do
            if [[ -f "$file" ]]; then
                mv "$file" "$ext/"
                print_status "Organized: $file -> $ext/"
            fi
        done
    done
    
    print_status "Organization complete in $dir"
    cd - &>/dev/null
}

# Main menu for file manager
file_manager_menu() {
    while true; do
        echo -e "\n${GREEN}=== File Manager ===${NC}"
        echo "1. Copy files"
        echo "2. Move files"
        echo "3. Delete file/dir"
        echo "4. Organize files by extension"
        echo "5. Exit"
        read -r choice
        
        case "$choice" in
            1) copy_files ;;
            2) move_files ;;
            3)
                echo "Enter path to delete:"
                read -r path
                delete_file "$path"
                ;;
            4)
                echo "Enter directory to organize:"
                read -r dir
                organize_files "$dir"
                ;;
            5) break ;;
            *) print_error "Invalid choice" ;;
        esac
    done
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    file_manager_menu
fi

