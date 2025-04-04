#!/bin/bash

options=(
    "bpp",
)

bpp() {
    local session_name="${FUNCNAME[0]}-mux"
    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux kill-session -t "$session_name"
    fi
    cd $HOME/Code/bisayaplusplus-interpreter
}

# Display menu
echo "Please select an option:"
for i in "${!options[@]}"; do
    echo "$((i+1)). ${options[$i]}"
done

# Get user input
read -p "Enter a number (1-${#options[@]}): " choice

# Validate input
if [[ ! "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#options[@]}" ]; then
    echo "Invalid input. Please enter a number between 1 and ${#options[@]}"
    exit 1
fi

# Execute function based on choice
case $choice in
    1)
        bpp
        ;;
esac
