#!/bin/bash

TARGET_DIR="/var/lib/rebecca/templates/subscription"
TEMP_REPO_DIR="/tmp/liquildGlassy-for-Rebecca"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${BOLD}${BLUE}  $1${NC}"
    echo -e "${CYAN}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}➜${NC} $1"
}

clear

print_header "LiquildGlassy Template Installer"
echo ""
echo -e "${BOLD}${CYAN}Custom subscription page template for Rebecca Panel${NC}"
echo -e "${BOLD}${CYAN}Designed by https://github.com/Incognito-Coder${NC}"
echo ""

print_info "Checking root privileges..."
if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run with root privileges (sudo)."
    exit 1
fi
print_success "Root privileges confirmed"

print_info "Checking target directory: $TARGET_DIR"
if [ -d "$TARGET_DIR" ]; then
    if [ -f "$TARGET_DIR/index.html" ]; then
        print_info "Existing index.html found, removing it..."
        rm -f "$TARGET_DIR/index.html"
        print_success "Old index.html removed"
    else
        print_info "No existing index.html found"
    fi
else
    print_info "Target directory doesn't exist, creating it..."
    mkdir -p "$TARGET_DIR"
    print_success "Directory created"
fi

print_info "Cleaning up temporary files..."
rm -rf "$TEMP_REPO_DIR"
print_success "Temporary files cleaned"

print_info "Fetching latest template from repository..."
echo -e "${BLUE}Cloning repository...${NC}"
git clone https://github.com/im-https/liquildGlassy-for-Rebecca.git "$TEMP_REPO_DIR" 2>&1 | sed 's/^/   /'

if [ $? -ne 0 ]; then
    print_error "Failed to clone repository. Please check your internet connection."
    exit 1
fi
print_success "Repository cloned successfully"

print_info "Looking for template files..."
THEME_FILE="liquildGlassy.html"
THEME_SOURCE="$TEMP_REPO_DIR/themes/$THEME_FILE"

if [ ! -f "$THEME_SOURCE" ]; then
    print_info "Default theme not found, searching for available themes..."
    FOUND_FILE=$(find "$TEMP_REPO_DIR/themes" -maxdepth 1 -name "*.html" | head -n 1)
    if [ -n "$FOUND_FILE" ]; then
        THEME_SOURCE="$FOUND_FILE"
        THEME_NAME=$(basename "$FOUND_FILE" .html)
        print_success "Found template: $THEME_NAME"
    else
        print_error "No HTML template files found in the themes directory."
        rm -rf "$TEMP_REPO_DIR"
        exit 1
    fi
else
    print_success "Found default template: liquildGlassy"
fi

print_info "Installing template..."
if [ -f "$THEME_SOURCE" ]; then
    cp "$THEME_SOURCE" "$TARGET_DIR/index.html"
    print_success "Template installed successfully"
else
    print_error "Template file not found at $THEME_SOURCE"
    rm -rf "$TEMP_REPO_DIR"
    exit 1
fi

print_info "Cleaning up temporary files..."
rm -rf "$TEMP_REPO_DIR"
print_success "Cleanup completed"

echo ""
print_header "Installation Complete!"
echo ""

echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                          ║${NC}"
echo -e "${GREEN}║  ${BOLD}✓ Template installed successfully!${NC}${GREEN}                          ║${NC}"
echo -e "${GREEN}║                                                          ║${NC}"
echo -e "${GREEN}║  📁 Location: ${BOLD}$TARGET_DIR/index.html${NC}${GREEN}       ║${NC}"
echo -e "${GREEN}║                                                          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BOLD}${CYAN}Next Steps:${NC}"
echo -e "  ${YELLOW}1.${NC} In Rebecca Panel, go to ${BOLD}Settings${NC} → ${BOLD}Subscriptions${NC}"
echo -e "  ${YELLOW}2.${NC} In the ${BOLD}Custom templates directory${NC} field, enter:"
echo -e "     ${CYAN}/var/lib/rebecca/templates${NC}"
echo -e "  ${YELLOW}3.${NC} ${BOLD}Save${NC} the settings and ${BOLD}restart${NC} the panel service"
echo -e "  ${YELLOW}4.${NC} Your custom subscription page is now ready! 🎉"
echo ""

echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
echo -e "${BOLD}${BLUE}Forked by:${NC} ${BOLD}${CYAN}https://t.me/im_https${NC}"
echo -e "${BOLD}${BLUE}Designed by:${NC} ${BOLD}${CYAN}https://github.com/Incognito-Coder${NC}"
echo -e "${CYAN}────────────────────────────────────────────────────────────${NC}"
echo ""

exit 0
