#!/bin/bash

# Check if required tools are available
if ! command -v ykman &> /dev/null; then
    echo "Error: ykman is not installed or not in PATH"
    exit 1
fi

if ! command -v rofi &> /dev/null; then
    echo "Error: rofi is not installed or not in PATH"
    exit 1
fi

if ! command -v xclip &> /dev/null && ! command -v wl-copy &> /dev/null; then
    echo "Error: Neither xclip nor wl-copy is available for clipboard access"
    exit 1
fi

# Get list of OTP accounts
accounts=$(ykman oath accounts list 2>/dev/null)

if [ -z "$accounts" ]; then
    echo "No OTP accounts found on YubiKey"
    exit 1
fi

# Use rofi to select account
selected_account=$(echo "$accounts" | rofi -dmenu -i -p "Select OTP account")

if [ -z "$selected_account" ]; then
    echo "No account selected"
    exit 0
fi

# Generate OTP code for selected account
otp_code=$(ykman oath accounts code "$selected_account" 2>/dev/null | awk '{print $NF}')

if [ -z "$otp_code" ]; then
    echo "Failed to generate OTP code for: $selected_account"
    exit 1
fi

# Copy to clipboard
if command -v wl-copy &> /dev/null; then
    echo -n "$otp_code" | wl-copy
    echo "OTP code for '$selected_account' copied to clipboard (Wayland)"
elif command -v xclip &> /dev/null; then
    echo -n "$otp_code" | xclip -selection clipboard
    echo "OTP code for '$selected_account' copied to clipboard (X11)"
fi