#!/bin/bash

# Target directory for template file
TARGET_DIR="/var/lib/rebecca/templates/subscription"
# Temporary directory for cloning the repository
TEMP_REPO_DIR="/tmp/liquildGlassy-for-Rebecca"

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting LiquildGlassy template installation for Rebecca Panel...${NC}"

# 1. Check for root privileges (required for writing to /var/lib)
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run with root privileges (sudo).${NC}"
   exit 1
fi

# 2. Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# 3. Remove old temporary directory (if it exists)
rm -rf "$TEMP_REPO_DIR"

# 4. Clone the repository
echo -e "${GREEN}Fetching the latest template version from repository...${NC}"
git clone https://github.com/im-https/liquildGlassy-for-Rebecca.git "$TEMP_REPO_DIR"

# 5. Check if clone was successful
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to clone repository. Please check your internet connection.${NC}"
    exit 1
fi

# 6. Find and copy the index.html file
#    Based on repository structure, HTML files are directly in the themes folder
#    We'll look for any .html file and copy the first one found
#    or you can specify a specific one like "liquildGlassy.html"
THEME_FILE="liquildGlassy.html"  # Default theme file
THEME_SOURCE="$TEMP_REPO_DIR/themes/$THEME_FILE"

# If default file doesn't exist, try to find any .html file in themes folder
if [ ! -f "$THEME_SOURCE" ]; then
    echo -e "${GREEN}Default theme file not found, looking for any HTML file in themes folder...${NC}"
    # Find first .html file in themes directory
    FOUND_FILE=$(find "$TEMP_REPO_DIR/themes" -maxdepth 1 -name "*.html" | head -n 1)
    if [ -n "$FOUND_FILE" ]; then
        THEME_SOURCE="$FOUND_FILE"
        echo -e "${GREEN}Found template file: $THEME_SOURCE${NC}"
    else
        echo -e "${RED}No HTML template files found in the themes directory.${NC}"
        echo -e "${RED}Please check the repository structure.${NC}"
        rm -rf "$TEMP_REPO_DIR"
        exit 1
    fi
fi

# 7. Copy the template file to target directory as index.html
if [ -f "$THEME_SOURCE" ]; then
    echo -e "${GREEN}Copying template from: $THEME_SOURCE${NC}"
    cp "$THEME_SOURCE" "$TARGET_DIR/index.html"
    echo -e "${GREEN}Successfully copied template to $TARGET_DIR/index.html${NC}"
else
    echo -e "${RED}Error: Template file not found at $THEME_SOURCE${NC}"
    rm -rf "$TEMP_REPO_DIR"
    exit 1
fi

# 8. Cleanup: Remove temporary directory
rm -rf "$TEMP_REPO_DIR"
echo -e "${GREEN}Cleanup completed.${NC}"

# 9. Final instructions
echo -e "${GREEN}Installation completed successfully!${NC}"
echo "Next steps:"
echo "1. In Rebecca Panel, go to Settings -> Subscriptions."
echo "2. In the 'Custom templates directory' field, enter the following path:"
echo "   /var/lib/rebecca/templates"
echo "3. Save the settings and restart the panel service."
echo "Your custom subscription page should now be displayed."

exit 0
