#!/bin/bash

check_and_install_jq() {
    if command -v jq &>/dev/null; then
        echo "jq is already installed."
        return 0
    fi

    echo "jq is not installed. Attempting to install..."

    # Detect package manager and install jq
    if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y jq
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y jq
    elif command -v yum &>/dev/null; then
        sudo yum install -y jq
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm jq
    elif command -v zypper &>/dev/null; then
        sudo zypper install -y jq
    elif command -v brew &>/dev/null; then
        brew install jq
    else
        echo "Unsupported package manager. Please install jq manually."
        return 1
    fi

    # Verify installation
    if command -v jq &>/dev/null; then
        echo "jq successfully installed."
    else
        echo "jq installation failed."
        return 1
    fi
}
check_and_install_jq
clear

# Define the API URL and target directory
API_URL="https://api.github.com/repos/incognito-coder/tx-themehub/contents/themes"
TARGET_DIR="/etc/x-ui/html"

# Fetch the list of theme names
themes=($(curl -s "$API_URL" | jq -r '.[].name'))

# Check if themes were retrieved successfully
if [ ${#themes[@]} -eq 0 ]; then
    echo "No themes found or failed to fetch data."
    exit 1
fi

# Display the themes as a selectable menu
echo "Select a theme:"
select theme in "${themes[@]}"; do
    if [ -n "$theme" ]; then
        echo "You selected: $theme"

        # Download the selected theme file
        FILE_URL="https://raw.githubusercontent.com/incognito-coder/tx-themehub/main/themes/$theme"
        TEMP_FILE="/tmp/$theme"

        echo "Downloading $theme..."
        curl -s -o "$TEMP_FILE" "$FILE_URL"

        # Check if the file was downloaded successfully
        if [ ! -s "$TEMP_FILE" ]; then
            echo "Failed to download $theme. Please check the file URL."
            exit 1
        fi

        # Create the directory if it doesn't exist
        if [ ! -d "$TARGET_DIR" ]; then
            mkdir -p "$TARGET_DIR"
        fi
        
        # Rename and move the file
        sudo mv "$TEMP_FILE" "$TARGET_DIR/sub.html"

        # Set appropriate permissions
        sudo chmod 644 "$TARGET_DIR/sub.html"
        echo "Theme successfully renamed to 'sub.html' and moved to $TARGET_DIR."

        # Applying Changes
        echo "Restarting TX-UI ..."
        sudo x-ui restart
        break
    else
        echo "Invalid selection. Please try again."
    fi
done
