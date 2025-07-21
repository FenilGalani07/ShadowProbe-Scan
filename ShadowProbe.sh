#!/bin/bash

# Trap Ctrl+C
trap "echo -e '\n\e[1;31mAborted by user. Exiting...\e[0m'; exit" SIGINT

function check_dependencies() {
    local deps=("nmap" "figlet")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo -e "\e[1;31mMissing dependency:\e[0m $dep"
            read -p "Do you want to install $dep? (y/n): " choice
            if [[ "$choice" =~ ^[Yy]$ ]]; then
                sudo apt update
                sudo apt install "$dep" -y
            else
                echo -e "\e[1;31mCannot continue without $dep. Exiting...\e[0m"
                exit 1
            fi
        fi
    done
}


function show_header() {
    clear
    echo -ne "\e[1;34mInitializing ShadowProbe Scan"
    for i in {1..3}; do
        sleep 0.5
        echo -n "."
    done
    echo -e "\e[0m\n"
    sleep 0.5

    CYAN="\e[1;36m"
    YELLOW="\e[1;33m"
    RESET="\e[0m"

    echo -e "${CYAN}"
    figlet -c " ShadowProbe" | while IFS= read -r line; do
        echo "$line"
        sleep 0.08
    done
    echo -e "${RESET}"

    local text=(
    "${YELLOW}Tool       : "Exploit" + "Scope" = comprehensive exploit scanner.${RESET}"
    "${YELLOW}Author     : Fenil Galani${RESET}"
    "${YELLOW}Project    : ShadowProbe Scan  |  Atmiya University${RESET}"
    "${YELLOW}LinkedIn   : www.linkedin.com/in/galani-fenil-372b042a7${RESET}"
    "${YELLOW}GitHub     : https://github.com/fenilgalani07${RESET}"
    "${YELLOW}----------------------------------------------${RESET}"
    ""
)

    for line in "${text[@]}"; do
        echo -e "$line"
        sleep 0.2
    done
}


check_dependencies


while true; do
    show_header

    echo -e "\e[1;32mSelect scan type:\e[0m"
options=(
    "\e[1;34m1.  Ping Scan\e[0m"
    "\e[1;34m2.  TCP SYN Scan\e[0m"
    "\e[1;34m3.  UDP Scan\e[0m"
    "\e[1;34m4.  OS Detection\e[0m"
    "\e[1;34m5.  Version Detection\e[0m"
    "\e[1;34m6.  Aggressive Scan\e[0m"
    "\e[1;34m7.  Fast Scan\e[0m"
    "\e[1;34m8.  All Ports Scan\e[0m"
    "\e[1;34m9.  Top Ports Scan\e[0m"
    "\e[1;34m10. Firewall Evasion\e[0m"
    "\e[1;34m11. Vulnerability Scan\e[0m"
    "\e[1;34m12. NSE Script Scan\e[0m"
    "\e[1;34m13. Decoy Scan\e[0m"
    "\e[1;34m14. Traceroute\e[0m"
    "\e[1;34m15. Custom Ports\e[0m"
    "\e[1;34m16. Output to File\e[0m"
    "\e[1;34m17. Spoof MAC\e[0m"
    "\e[1;34m18. DNS Brute Force\e[0m"
    "\e[1;34m19. HTTP Title Enumeration\e[0m"
    "\e[1;34m20. SMB Enumeration\e[0m"
    "\e[1;34m21. FTP Anonymous Login Check\e[0m"
    "\e[1;34m22. SSL Certificate Info\e[0m"
    "\e[1;34m23. Detect Web Application Firewall\e[0m"
    "\e[1;34m24. HTTP Methods Check\e[0m"
    "\e[1;34m25. Extract HTTP Robots.txt\e[0m"
    "\e[1;34m26. Whois Lookup\e[0m"
    "\e[1;34m27. Run All Safe Scripts\e[0m"
    "\e[1;34m28. Exit\e[0m"
)


for opt in "${options[@]}"; do
    echo -e "$opt"
done

    echo -ne "\nEnter option number: "
    read opt

    case $opt in
        1)
            read -p "Enter target: " target
            nmap -sn "$target"
            ;;
        2)
            read -p "Enter target: " target
            nmap -sS "$target"
            ;;
        3)
            read -p "Enter target: " target
            nmap -sU "$target"
            ;;
        4)
            read -p "Enter target: " target
            nmap -O "$target"
            ;;
        5)
            read -p "Enter target: " target
            nmap -sV "$target"
            ;;
        6)
            read -p "Enter target: " target
            nmap -A "$target"
            ;;
        7)
            read -p "Enter target: " target
            nmap -F "$target"
            ;;
        8)
            read -p "Enter target: " target
            nmap -p- "$target"
            ;;
        9)
            read -p "Enter target: " target
            nmap --top-ports 100 "$target"
            ;;
        10)
            read -p "Enter target: " target
            nmap -f --data-length 200 "$target"
            ;;
        11)
            read -p "Enter target: " target
            nmap --script vuln "$target"
            ;;
        12)
            read -p "Enter target: " target
            nmap --script default,vuln "$target"
            ;;
        13)
            read -p "Enter target: " target
            read -p "Enter decoy IP (or RND:10): " decoy
            nmap -D "$decoy" "$target"
            ;;
        14)
            read -p "Enter target: " target
            nmap --traceroute "$target"
            ;;
        15)
            read -p "Enter target: " target
            read -p "Enter ports (e.g. 21,22,80): " ports
            nmap -p "$ports" "$target"
            ;;
        16)
            read -p "Enter target: " target
            read -p "Output filename (no extension): " filename
            nmap -A -oA "$filename" "$target"
            ;;
        17)
            read -p "Enter target: " target
            read -p "Enter MAC type (e.g. 0=random): " mac
            nmap --spoof-mac "$mac" "$target"
            ;;
        18)
            read -p "Enter domain: " target
            nmap --script dns-brute "$target"
            ;;
        19)
            read -p "Enter target: " target
            nmap --script http-title "$target"
            ;;
        20)
            read -p "Enter target: " target
            nmap --script smb-enum-shares,smb-enum-users "$target"
            ;;
        21)
            read -p "Enter target: " target
            nmap --script ftp-anon "$target"
            ;;
        22)
            read -p "Enter target: " target
            nmap --script ssl-cert "$target"
            ;;
        23)
            read -p "Enter target: " target
            nmap --script http-waf-detect "$target"
            ;;
        24)
            read -p "Enter target: " target
            nmap --script http-methods "$target"
            ;;
        25)
            read -p "Enter target: " target
            nmap --script http-robots.txt "$target"
            ;;
        26)
            read -p "Enter target: " target
            nmap --script whois "$target"
            ;;
        27)
            read -p "Enter target: " target
            nmap --script safe "$target"
            ;;
        28)
            echo -e "\n\e[1;31mExiting ShadowProbe Scan.. Goodbye!\e[0m"
            exit 0
            ;;
        *)
            echo -e "\e[1;31mInvalid option. Try again.\e[0m"
            ;;
    esac

    echo -e "\nPress ENTER to return to menu..."
    read
done

