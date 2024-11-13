#!/bin/bash

# Debugging in case of bugs
# set -e

# ////////////////////////////////////////////
# //  THIS IS A SHELL CODE TEMPLATE MODEL   //
# ////////////////////////////////////////////

# ==============================================
# | Date: 0000-00-00                           |
# ==============================================
# | Description: Bash Code Template Example.   |
# |                                            |
# ==============================================
# | Created By:                                |
# ==============================================

# Clear the screen
clear

# VARIABLES


# Colors
RED="\e[31m"        # Classic RED
GREEN="\e[32m"      # Classic GREEN
YELLOW="\e[33m"     # Classic YELLOW
BLUE="\e[34m"       # Classic BLUE
PURPLE="\e[35m"     # Classic PURPLE
BG_RED="\e[41m"     # Background RED
BG_GREEN="\e[42m"   # Background GREEN
BG_YELLOW="\e[43m"  # Background YELLOW
BG_BLUE="\e[44m"    # Background BLUE
BG_PURPLE="\e[45m"  # Background PURPLE
NE="\e[0m"          # No color

# Functions

template_function() {
    echo -e "${GREEN}Hello World!${NE}"
}

# Main function
main() {
    template_function
}

# Call the main function
main
