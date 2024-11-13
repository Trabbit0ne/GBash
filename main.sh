#!/bin/bash

# Debugging in case of bugs
# set -e

# --------------------------------------------------------
# Youtube: TrabbitOne
# BuyMeACoffee: trabbit0ne
# Bitcoin: bc1qehnsx5tdwkulamttzla96dmv82ty9ak8l5yy40
# --------------------------------------------------------
# Bash code Verifier
# Author: Trabbit
# Date: 2024-07-13
# --------------------------------------------------------

# Clear the screen
clear

# VARIABLES
file=$1

# Colors
R="\e[31m"        # Classic RED
G="\e[32m"        # Classic GREEN
Y="\e[33m"        # Classic YELLOW
B="\e[34m"        # Classic BLUE
P="\e[35m"        # Classic PURPLE
W="\e[37m"        # Classic WHITE
BGR="\e[41m"      # Background RED
BGG="\e[42m"      # Background GREEN
BGY="\e[43m"      # Background YELLOW
BGB="\e[44m"      # Background BLUE
BGP="\e[45m"      # Background PURPLE
N="\e[0m"         # No color

# Variables for calculating percentage of "good"
total_checks=6
good_checks=0
increment=$(echo "scale=2; 100 / $total_checks" | bc)

# Functions

BANNER() {
    echo " _______ _______             __     "
    echo "|   _   |   _   .---.-.-----|  |--. "
    echo "|.  |___|.  1   |  _  |__ --|     | "
    echo "|.  |   |.  _   |___._|_____|__|__| "
    echo "|:  1   |:  1    \ ====== TRABBIT =="
    echo "|::.. . |::.. .  /                  "
    echo "'-------'-------'                   "
    echo
    echo "===================================="
    echo " File: $basename_file"
    echo " Lines: $line_amount "
    echo "===================================="
    echo
}

CHECK_CONFIGS() {
    # Verify if the file is provided or input is piped
    if [[ -z $file && -t 0 ]]; then
        echo -e "${R}ERROR: Please provide a file or pipe input.${N}"
        echo "            [Usage] "
        echo "{+}=========================={+}"
        echo "   - gbash <file(.sh)>"
        echo "   - cat <file(.sh)> | gbash"
        echo "{+}=========================={+}"
        exit 1
    fi
}

CHECK_EXTENSION() {
    # Check if the file has a .sh extension
    if [[ "$file" != *.sh ]]; then
        echo -e " [+] ${R}File Extension: ${N}[${BGR}${W}INVALID${N}]"
    else
        echo -e " [+] ${G}File Extension: ${N}[${BGG}${W}VALID${N}]"
        ((good_checks++))
    fi
}

CHECK_CODE() {
    local shebangs=("#!/bin/bash" "#!/usr/bin/env bash")
    local first_line

    # Read the first line of the file or piped input
    if [[ -n $file && -f $file ]]; then
        read -r first_line < "$file"
    elif [[ -p /dev/stdin ]]; then
        read -r first_line
    else
        echo -e "${R}ERROR: File not found or invalid input.${N}"
        exit 1
    fi

    # Check if the first line matches any shebang
    for shebang in "${shebangs[@]}"; do
        if [[ "$first_line" == "$shebang" ]]; then
            echo -e " [+] ${G}Shebang: ${N}[${BGG}${W}DETECTED${N}]"
            ((good_checks++))
            return 0
        fi
    done

    echo -e " [+] ${Y}Shebang: ${N}[${BGR}${W}NOT FOUND${N}]"
}

CHECK_BANNER() {
    if grep -qE '^[# ]{1,3}[=/]{10,}' "$file"; then
        echo -e " [+] ${G}Banner: ${N}[${BGG}${W}DETECTED${N}]"
        ((good_checks++))
    else
        echo -e " [+] ${R}Banner: ${N}[${BGR}${W}NOT FOUND${N}]"
    fi
}

CHECK_MAIN_FUNCTION() {
    # Check if the 'main' function is defined
    if grep -qE '^[[:space:]]*main[[:space:]]*\(\)[[:space:]]*{.*' "$file"; then
        echo -e " [+] ${G}Main function: ${N}[${BGG}${W}DETECTED${N}]"
        ((good_checks++))
    else
        echo -e " [+] ${R}No main function: ${N}[${BGR}${W}NOT FOUND${N}]"
    fi
}

CHECK_COMMENTS() {
    # Ignore the first line (shebang), and check for comments from the second line onwards
    if tail -n +2 "$file" | grep -qE '^[[:space:]]*#'; then
        echo -e " [+] ${G}Comments: ${N}[${BGG}${W}DETECTED${N}]"
        ((good_checks++))
    else
        echo -e " [+] ${R}Comments: ${N}[${BGR}${W}NOT FOUND${N}]"
    fi
}

CHECK_SYNTAX_ERRORS() {
    # Check for syntax errors using bash -n
    if bash -n "$file" &> /dev/null; then
        echo -e " [+] ${G}Syntax Errors: ${N}[${BGG}${W}NONE${N}]"
        ((good_checks++))
    else
        echo -e " [+] ${R}Syntax Errors: ${N}[${BGR}${W}FOUND${N}]"
    fi
}

SHOW_PROGRESS() {
    # Calculate the percentage
    percentage=$(echo "$good_checks * $increment" | bc)
    if (( $(echo "$percentage > 100" | bc -l) )); then
        percentage=100
    fi
    echo
    echo -e "${B}Score: ${N}${percentage}%"
}

# Main function
main() {
    CHECK_CONFIGS

    # Read input from pipe if available
    if [[ -p /dev/stdin ]]; then
        file=$(mktemp)
        cat > "$file"
    fi

    # Get the basename and line amount after handling input
    basename_file=$(basename "$file")
    line_amount=$(wc -l < "$file")

    BANNER
    CHECK_EXTENSION
    CHECK_CODE
    CHECK_BANNER
    CHECK_MAIN_FUNCTION
    CHECK_COMMENTS
    CHECK_SYNTAX_ERRORS
    SHOW_PROGRESS

    # Clean up temporary file if created
    if [[ -n $tmp_file ]]; then
        rm "$tmp_file"
    fi
}

# Call the main function
main
